# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_redis_instance/resource'

RSpec.describe 'google_redis_instance synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_redis_instance(:test, { name: "my-redis", region: "us-central1", memory_size_gb: 1, tier: "BASIC" })
      end
    }.synthesis
    expect(result[:resource][:google_redis_instance][:test]).to be_a(Hash)
  end
end
