# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_secret_manager_secret_version/resource'

RSpec.describe 'google_secret_manager_secret_version synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_secret_manager_secret_version,
    provider: Pangea::Resources::Google,
    required_attrs: { secret: 'projects/test/secrets/test', secret_data: 'test-value' },
    expected_outputs: [:id, :name, :version]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_secret_manager_secret_version(:test, { secret: "projects/my-project/secrets/my-secret", secret_data: "super-secret-value" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_secret_manager_secret_version][:test]).to be_a(Hash)
  end

  it 'synthesizes with enabled flag and deletion policy' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_secret_manager_secret_version(:full, {
        secret: "projects/my-project/secrets/db-password",
        secret_data: "p@ssw0rd!",
        enabled: false,
        deletion_policy: "DISABLE"
      })
    end
    result = synthesizer.synthesis
    ver = result[:resource][:google_secret_manager_secret_version][:full]
    expect(ver[:enabled]).to eq(false)
    expect(ver[:deletion_policy]).to eq("DISABLE")
  end

  it 'raises error when required secret_data is missing' do
    expect {
      Google::Types::SecretManagerSecretVersionAttributes.new(
        secret: "projects/my-project/secrets/test"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with version output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_secret_manager_secret_version(:ref_test, { secret: "s", secret_data: "d" })
    end
    expect(ref.type).to eq('google_secret_manager_secret_version')
    expect(ref.outputs[:version]).to eq("${google_secret_manager_secret_version.ref_test.version}")
    expect(ref.outputs[:name]).to eq("${google_secret_manager_secret_version.ref_test.name}")
  end
end
