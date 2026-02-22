# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_storage_bucket/resource'

RSpec.describe 'google_storage_bucket synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_storage_bucket(:test, { name: "my-bucket-unique-123", location: "US" })
      end
    }.synthesis
    expect(result[:resource][:google_storage_bucket][:test]).to be_a(Hash)
  end
end
