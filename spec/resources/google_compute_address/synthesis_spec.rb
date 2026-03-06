# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_address/resource'

RSpec.describe 'google_compute_address synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_compute_address,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-addr' },
    expected_outputs: [:id, :address, :self_link]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_address(:test, { name: "my-address", region: "us-central1", address_type: "EXTERNAL" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_compute_address][:test]).to be_a(Hash)
  end

  it 'synthesizes internal address with subnetwork' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_address(:internal, {
        name: "internal-ip",
        region: "us-central1",
        address_type: "INTERNAL",
        address: "10.0.0.42",
        subnetwork: "projects/my-project/regions/us-central1/subnetworks/my-subnet",
        network_tier: "PREMIUM",
        labels: { "purpose" => "database" }
      })
    end
    result = synthesizer.synthesis
    addr = result[:resource][:google_compute_address][:internal]
    expect(addr[:address_type]).to eq("INTERNAL")
    expect(addr[:address]).to eq("10.0.0.42")
    expect(addr[:network_tier]).to eq("PREMIUM")
  end

  it 'rejects invalid address_type enum value' do
    expect {
      Google::Types::ComputeAddressAttributes.new(
        name: "test", address_type: "GLOBAL"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'rejects invalid network_tier enum value' do
    expect {
      Google::Types::ComputeAddressAttributes.new(
        name: "test", network_tier: "BASIC"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with address output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_compute_address(:ref_test, { name: "ref-addr" })
    end
    expect(ref.type).to eq('google_compute_address')
    expect(ref.outputs[:address]).to eq("${google_compute_address.ref_test.address}")
  end
end
