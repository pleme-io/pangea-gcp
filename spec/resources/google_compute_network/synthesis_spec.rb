# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_network/resource'

RSpec.describe 'google_compute_network synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_compute_network,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-vpc' },
    expected_outputs: [:id, :self_link]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_network(:test, { name: "my-network" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_compute_network][:test]).to be_a(Hash)
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_network(:full, {
        name: "custom-vpc",
        project: "my-project-id",
        auto_create_subnetworks: false,
        routing_mode: "GLOBAL",
        description: "Custom VPC network",
        mtu: 1460,
        delete_default_routes_on_create: true
      })
    end
    result = synthesizer.synthesis
    network = result[:resource][:google_compute_network][:full]
    expect(network[:auto_create_subnetworks]).to eq(false)
    expect(network[:routing_mode]).to eq("GLOBAL")
    expect(network[:mtu]).to eq(1460)
    expect(network[:delete_default_routes_on_create]).to eq(true)
  end

  it 'rejects invalid routing_mode enum value' do
    expect {
      Google::Types::ComputeNetworkAttributes.new(
        name: "test", routing_mode: "LOCAL"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with correct outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_compute_network(:ref_test, { name: "ref-net" })
    end
    expect(ref.type).to eq('google_compute_network')
    expect(ref.outputs[:id]).to eq("${google_compute_network.ref_test.id}")
    expect(ref.outputs[:self_link]).to eq("${google_compute_network.ref_test.self_link}")
  end
end
