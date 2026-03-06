# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_storage_bucket/resource'

RSpec.describe 'google_storage_bucket synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_storage_bucket,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-bucket', location: 'US' },
    expected_outputs: [:id, :self_link, :url]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_storage_bucket(:test, { name: "my-bucket-unique-123", location: "US" })
    end
    result = synthesizer.synthesis
    bucket = result[:resource][:google_storage_bucket][:test]
    expect(bucket).to be_a(Hash)
    expect(bucket[:name]).to eq("my-bucket-unique-123")
    expect(bucket[:location]).to eq("US")
  end

  it 'synthesizes with lifecycle rules and versioning' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_storage_bucket(:full, {
        name: "full-bucket-abc",
        location: "US",
        storage_class: "NEARLINE",
        force_destroy: true,
        uniform_bucket_level_access: true,
        versioning: { enabled: true },
        lifecycle_rule: [
          {
            action: { type: "Delete" },
            condition: { age: 365 }
          },
          {
            action: { type: "SetStorageClass", storage_class: "COLDLINE" },
            condition: { age: 90 }
          }
        ],
        labels: { "env" => "staging" }
      })
    end
    result = synthesizer.synthesis
    bucket = result[:resource][:google_storage_bucket][:full]
    expect(bucket[:storage_class]).to eq("NEARLINE")
    expect(bucket[:force_destroy]).to eq(true)
    expect(bucket[:uniform_bucket_level_access]).to eq(true)
    expect(bucket[:versioning]).to eq({ enabled: true })
  end

  it 'synthesizes with cors and encryption config' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_storage_bucket(:cors_enc, {
        name: "cors-bucket-xyz",
        location: "EU",
        cors: [{ origin: ["https://example.com"], method: ["GET", "POST"], max_age_seconds: 3600 }],
        encryption: { default_kms_key_name: "projects/p/locations/l/keyRings/kr/cryptoKeys/ck" },
        logging: { log_bucket: "log-bucket", log_object_prefix: "access-logs/" }
      })
    end
    result = synthesizer.synthesis
    bucket = result[:resource][:google_storage_bucket][:cors_enc]
    expect(bucket[:cors]).to be_a(Array)
    expect(bucket[:encryption]).to be_a(Hash)
    expect(bucket[:logging]).to be_a(Hash)
  end

  it 'rejects invalid storage_class enum value' do
    expect {
      Google::Types::StorageBucketAttributes.new(
        name: "test", location: "US", storage_class: "INVALID"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with url output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_storage_bucket(:ref_test, { name: "ref-bucket-123", location: "US" })
    end
    expect(ref.type).to eq('google_storage_bucket')
    expect(ref.outputs[:url]).to eq("${google_storage_bucket.ref_test.url}")
    expect(ref.outputs[:self_link]).to eq("${google_storage_bucket.ref_test.self_link}")
  end
end
