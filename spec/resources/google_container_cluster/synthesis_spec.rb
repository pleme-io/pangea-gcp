# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_container_cluster/resource'

RSpec.describe 'google_container_cluster synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_container_cluster(:test, { name: "my-cluster", location: "us-central1", initial_node_count: 1, remove_default_node_pool: true })
      end
    }.synthesis
    expect(result[:resource][:google_container_cluster][:test]).to be_a(Hash)
  end
end
