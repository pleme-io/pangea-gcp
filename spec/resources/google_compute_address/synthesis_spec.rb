# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_address/resource'

RSpec.describe 'google_compute_address synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_compute_address(:test, { name: "my-address", region: "us-central1", address_type: "EXTERNAL" })
      end
    }.synthesis
    expect(result[:resource][:google_compute_address][:test]).to be_a(Hash)
  end
end
