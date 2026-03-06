# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_subnetwork/resource'

RSpec.describe 'google_compute_subnetwork synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_compute_subnetwork,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-subnet', region: 'us-central1', network: 'default', ip_cidr_range: '10.0.0.0/24' },
    expected_outputs: [:id, :self_link, :gateway_address]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_subnetwork(:test, { name: "my-subnet", region: "us-central1", network: "my-network", ip_cidr_range: "10.0.0.0/24" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_compute_subnetwork][:test]).to be_a(Hash)
  end

  it 'synthesizes with secondary IP ranges and private Google access' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_subnetwork(:full, {
        name: "gke-subnet",
        project: "my-project",
        region: "us-central1",
        network: "my-vpc",
        ip_cidr_range: "10.0.0.0/20",
        description: "GKE subnet with secondary ranges",
        private_ip_google_access: true,
        secondary_ip_range: [
          { range_name: "pods", ip_cidr_range: "10.4.0.0/14" },
          { range_name: "services", ip_cidr_range: "10.8.0.0/20" }
        ]
      })
    end
    result = synthesizer.synthesis
    subnet = result[:resource][:google_compute_subnetwork][:full]
    expect(subnet[:private_ip_google_access]).to eq(true)
    expect(subnet[:secondary_ip_range]).to be_a(Array)
    expect(subnet[:secondary_ip_range].length).to eq(2)
  end

  it 'returns a ResourceReference with gateway_address output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_compute_subnetwork(:ref_test, { name: "ref-subnet", region: "us-central1", network: "net", ip_cidr_range: "10.0.0.0/24" })
    end
    expect(ref.type).to eq('google_compute_subnetwork')
    expect(ref.outputs[:gateway_address]).to eq("${google_compute_subnetwork.ref_test.gateway_address}")
    expect(ref.outputs[:self_link]).to eq("${google_compute_subnetwork.ref_test.self_link}")
  end
end
