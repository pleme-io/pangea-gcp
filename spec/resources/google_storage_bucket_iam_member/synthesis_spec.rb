# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_storage_bucket_iam_member/resource'

RSpec.describe 'google_storage_bucket_iam_member synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_storage_bucket_iam_member(:test, { bucket: "my-bucket", role: "roles/storage.objectViewer", member: "user:test@example.com" })
      end
    }.synthesis
    expect(result[:resource][:google_storage_bucket_iam_member][:test]).to be_a(Hash)
  end
end
