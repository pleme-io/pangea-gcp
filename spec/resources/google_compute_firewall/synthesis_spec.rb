# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_firewall/resource'

RSpec.describe 'google_compute_firewall synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_compute_firewall(:test, { name: "allow-ssh", network: "my-network", allow: [{ protocol: "tcp", ports: ["22"] }], source_ranges: ["0.0.0.0/0"] })
      end
    }.synthesis
    expect(result[:resource][:google_compute_firewall][:test]).to be_a(Hash)
  end
end
