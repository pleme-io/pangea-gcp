# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_subnetwork/resource'

RSpec.describe 'google_compute_subnetwork synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_compute_subnetwork(:test, { name: "my-subnet", region: "us-central1", network: "my-network", ip_cidr_range: "10.0.0.0/24" })
      end
    }.synthesis
    expect(result[:resource][:google_compute_subnetwork][:test]).to be_a(Hash)
  end
end
