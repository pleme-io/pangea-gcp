# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_container_cluster/resource'

RSpec.describe 'google_container_cluster synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_container_cluster,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-cluster', location: 'us-central1' },
    expected_outputs: [:id, :endpoint, :master_version, :self_link]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_container_cluster(:test, { name: "my-cluster", location: "us-central1", initial_node_count: 1, remove_default_node_pool: true })
    end
    result = synthesizer.synthesis
    cluster = result[:resource][:google_container_cluster][:test]
    expect(cluster).to be_a(Hash)
    expect(cluster[:name]).to eq("my-cluster")
    expect(cluster[:location]).to eq("us-central1")
  end

  it 'synthesizes with all optional attributes including nested configs' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_container_cluster(:full, {
        name: "prod-cluster",
        project: "my-gcp-project",
        location: "us-central1",
        initial_node_count: 3,
        remove_default_node_pool: true,
        network: "projects/my-project/global/networks/my-vpc",
        subnetwork: "projects/my-project/regions/us-central1/subnetworks/my-subnet",
        description: "Production GKE cluster",
        min_master_version: "1.27",
        deletion_protection: false,
        networking_mode: "VPC_NATIVE",
        ip_allocation_policy: {
          cluster_secondary_range_name: "pods",
          services_secondary_range_name: "services"
        },
        private_cluster_config: {
          enable_private_nodes: true,
          enable_private_endpoint: false,
          master_ipv4_cidr_block: "172.16.0.0/28"
        },
        master_auth: {
          client_certificate_config: { issue_client_certificate: false }
        },
        workload_identity_config: {
          workload_pool: "my-project.svc.id.goog"
        },
        release_channel: { channel: "REGULAR" },
        resource_labels: { "env" => "production", "managed-by" => "pangea" }
      })
    end
    result = synthesizer.synthesis
    cluster = result[:resource][:google_container_cluster][:full]
    expect(cluster[:networking_mode]).to eq("VPC_NATIVE")
    expect(cluster[:deletion_protection]).to eq(false)
    expect(cluster[:private_cluster_config]).to be_a(Hash)
    expect(cluster[:resource_labels]).to eq({ "env" => "production", "managed-by" => "pangea" })
  end

  it 'rejects invalid networking_mode enum value' do
    expect {
      Google::Types::ContainerClusterAttributes.new(
        name: "test", location: "us-central1", networking_mode: "INVALID_MODE"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with correct outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_container_cluster(:ref_test, { name: "ref-cluster", location: "us-central1" })
    end
    expect(ref.type).to eq('google_container_cluster')
    expect(ref.outputs[:id]).to eq("${google_container_cluster.ref_test.id}")
    expect(ref.outputs[:endpoint]).to eq("${google_container_cluster.ref_test.endpoint}")
    expect(ref.outputs[:master_version]).to eq("${google_container_cluster.ref_test.master_version}")
    expect(ref.outputs[:self_link]).to eq("${google_container_cluster.ref_test.self_link}")
  end
end
