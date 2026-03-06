# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_secret_manager_secret/resource'

RSpec.describe 'google_secret_manager_secret synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_secret_manager_secret,
    provider: Pangea::Resources::Google,
    required_attrs: { secret_id: 'test-secret', replication: { automatic: {} } },
    expected_outputs: [:id, :name]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_secret_manager_secret(:test, { secret_id: "my-secret", replication: { automatic: true } })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_secret_manager_secret][:test]).to be_a(Hash)
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_secret_manager_secret(:full, {
        secret_id: "db-password",
        project: "my-project",
        replication: {
          user_managed: {
            replicas: [
              { location: "us-central1" },
              { location: "us-east1" }
            ]
          }
        },
        labels: { "env" => "prod", "managed-by" => "pangea" },
        expire_time: "2027-01-01T00:00:00Z",
        ttl: "8640000s",
        rotation: {
          next_rotation_time: "2026-07-01T00:00:00Z",
          rotation_period: "7776000s"
        },
        topics: [{ name: "projects/my-project/topics/secret-notifications" }]
      })
    end
    result = synthesizer.synthesis
    secret = result[:resource][:google_secret_manager_secret][:full]
    expect(secret[:expire_time]).to eq("2027-01-01T00:00:00Z")
    expect(secret[:rotation]).to be_a(Hash)
    expect(secret[:topics]).to be_a(Array)
    expect(secret[:labels]).to include("managed-by" => "pangea")
  end

  it 'raises error when required replication is missing' do
    expect {
      Google::Types::SecretManagerSecretAttributes.new(secret_id: "test")
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with name output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_secret_manager_secret(:ref_test, { secret_id: "ref-secret", replication: { automatic: true } })
    end
    expect(ref.type).to eq('google_secret_manager_secret')
    expect(ref.outputs[:name]).to eq("${google_secret_manager_secret.ref_test.name}")
  end
end
