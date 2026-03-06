# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_storage_bucket_iam_member/resource'

RSpec.describe 'google_storage_bucket_iam_member synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_storage_bucket_iam_member,
    provider: Pangea::Resources::Google,
    required_attrs: { bucket: 'test-bucket', role: 'roles/storage.objectViewer', member: 'user:test@example.com' },
    expected_outputs: [:id]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_storage_bucket_iam_member(:test, { bucket: "my-bucket", role: "roles/storage.objectViewer", member: "user:test@example.com" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_storage_bucket_iam_member][:test]).to be_a(Hash)
  end

  it 'synthesizes with IAM condition' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_storage_bucket_iam_member(:conditional, {
        bucket: "secure-bucket",
        role: "roles/storage.objectAdmin",
        member: "serviceAccount:sa@project.iam.gserviceaccount.com",
        condition: {
          title: "expires_after_2025",
          description: "Expires at end of 2025",
          expression: "request.time < timestamp('2025-12-31T23:59:59Z')"
        }
      })
    end
    result = synthesizer.synthesis
    iam = result[:resource][:google_storage_bucket_iam_member][:conditional]
    expect(iam[:condition]).to be_a(Hash)
    expect(iam[:condition][:title]).to eq("expires_after_2025")
  end

  it 'raises error when required bucket is missing' do
    expect {
      Google::Types::StorageBucketIamMemberAttributes.new(
        role: "roles/storage.objectViewer",
        member: "user:test@example.com"
      )
    }.to raise_error(Dry::Struct::Error)
  end
end
