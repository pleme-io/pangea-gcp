# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_container_node_pool/resource'

RSpec.describe 'google_container_node_pool synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_container_node_pool,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-pool', location: 'us-central1', cluster: 'test-cluster' },
    expected_outputs: [:id, :instance_group_urls]

  it 'synthesizes with node config' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_container_node_pool(:test, { name: "my-pool", location: "us-central1", cluster: "my-cluster", node_count: 3, node_config: { machine_type: "e2-medium", disk_size_gb: 100, oauth_scopes: ["https://www.googleapis.com/auth/cloud-platform"] } })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_container_node_pool][:test]).to be_a(Hash)
  end

  it 'synthesizes with autoscaling and management config' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_container_node_pool(:auto, {
        name: "autoscaled-pool",
        location: "us-central1",
        cluster: "prod-cluster",
        autoscaling: {
          min_node_count: 1,
          max_node_count: 10
        },
        management: {
          auto_repair: true,
          auto_upgrade: true
        },
        max_pods_per_node: 110,
        node_locations: ["us-central1-a", "us-central1-b"],
        upgrade_settings: {
          max_surge: 1,
          max_unavailable: 0
        }
      })
    end
    result = synthesizer.synthesis
    pool = result[:resource][:google_container_node_pool][:auto]
    expect(pool[:autoscaling]).to be_a(Hash)
    expect(pool[:management]).to eq({ auto_repair: true, auto_upgrade: true })
    expect(pool[:max_pods_per_node]).to eq(110)
  end

  it 'returns a ResourceReference with instance_group_urls output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_container_node_pool(:ref_test, { name: "ref-pool", location: "us-central1", cluster: "cluster" })
    end
    expect(ref.type).to eq('google_container_node_pool')
    expect(ref.outputs[:instance_group_urls]).to eq("${google_container_node_pool.ref_test.instance_group_urls}")
  end
end
