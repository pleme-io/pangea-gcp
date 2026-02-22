# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_network/resource'

RSpec.describe 'google_compute_network synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_compute_network(:test, { name: "my-network" })
      end
    }.synthesis
    expect(result[:resource][:google_compute_network][:test]).to be_a(Hash)
  end
end
