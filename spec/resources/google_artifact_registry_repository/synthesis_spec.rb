# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_artifact_registry_repository/resource'

RSpec.describe 'google_artifact_registry_repository synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_artifact_registry_repository,
    provider: Pangea::Resources::Google,
    required_attrs: { repository_id: 'test-repo', location: 'us-central1', format: 'DOCKER' },
    expected_outputs: [:id, :name]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_artifact_registry_repository(:test, { repository_id: "my-repo", location: "us-central1", format: "DOCKER", description: "Docker images" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_artifact_registry_repository][:test]).to be_a(Hash)
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_artifact_registry_repository(:full, {
        repository_id: "docker-repo",
        project: "my-project",
        location: "us-central1",
        format: "DOCKER",
        description: "Production Docker registry",
        labels: { "env" => "prod" },
        kms_key_name: "projects/p/locations/l/keyRings/kr/cryptoKeys/ck",
        mode: "STANDARD_REPOSITORY",
        cleanup_policy_dry_run: false,
        cleanup_policies: [
          {
            id: "delete-old",
            action: "DELETE",
            condition: { older_than: "2592000s" }
          }
        ],
        docker_config: { immutable_tags: true },
        maven_config: nil
      })
    end
    result = synthesizer.synthesis
    repo = result[:resource][:google_artifact_registry_repository][:full]
    expect(repo[:mode]).to eq("STANDARD_REPOSITORY")
    expect(repo[:cleanup_policy_dry_run]).to eq(false)
    expect(repo[:docker_config]).to eq({ immutable_tags: true })
  end

  it 'accepts all valid format enum values in type validation' do
    %w[DOCKER MAVEN NPM PYTHON APT YUM GO KFP].each do |fmt|
      attrs = Google::Types::ArtifactRegistryRepositoryAttributes.new(
        repository_id: "test-repo", location: "us-central1", format: fmt
      )
      expect(attrs.format).to eq(fmt)
    end
  end

  it 'rejects invalid format enum value' do
    expect {
      Google::Types::ArtifactRegistryRepositoryAttributes.new(
        repository_id: "test", location: "us-central1", format: "OCI"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'rejects invalid mode enum value' do
    expect {
      Google::Types::ArtifactRegistryRepositoryAttributes.new(
        repository_id: "test", location: "us-central1", format: "DOCKER", mode: "MIRROR"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with name output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_artifact_registry_repository(:ref_test, { repository_id: "ref-repo", location: "us-central1", format: "DOCKER" })
    end
    expect(ref.type).to eq('google_artifact_registry_repository')
    expect(ref.outputs[:name]).to eq("${google_artifact_registry_repository.ref_test.name}")
  end
end
