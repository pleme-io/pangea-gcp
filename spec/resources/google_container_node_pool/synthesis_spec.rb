# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_container_node_pool/resource'

RSpec.describe 'google_container_node_pool synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_container_node_pool(:test, { name: "my-pool", location: "us-central1", cluster: "my-cluster", node_count: 3, node_config: { machine_type: "e2-medium", disk_size_gb: 100, oauth_scopes: ["https://www.googleapis.com/auth/cloud-platform"] } })
      end
    }.synthesis
    expect(result[:resource][:google_container_node_pool][:test]).to be_a(Hash)
  end
end
