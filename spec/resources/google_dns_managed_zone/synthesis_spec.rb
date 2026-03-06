# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_dns_managed_zone/resource'

RSpec.describe 'google_dns_managed_zone synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_dns_managed_zone,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-zone', dns_name: 'example.com.' },
    expected_outputs: [:id, :name_servers]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_dns_managed_zone(:test, { name: "my-zone", dns_name: "example.com.", description: "My DNS zone" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_dns_managed_zone][:test]).to be_a(Hash)
  end

  it 'synthesizes private zone with DNSSEC and private visibility' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_dns_managed_zone(:private, {
        name: "internal-zone",
        project: "my-project",
        dns_name: "internal.example.com.",
        description: "Private DNS zone",
        visibility: "private",
        dnssec_config: { state: "on" },
        private_visibility_config: {
          networks: [{ network_url: "projects/my-project/global/networks/my-vpc" }]
        },
        labels: { "env" => "internal" },
        force_destroy: true
      })
    end
    result = synthesizer.synthesis
    zone = result[:resource][:google_dns_managed_zone][:private]
    expect(zone[:visibility]).to eq("private")
    expect(zone[:force_destroy]).to eq(true)
    expect(zone[:dnssec_config]).to be_a(Hash)
  end

  it 'rejects invalid visibility enum value' do
    expect {
      Google::Types::DnsManagedZoneAttributes.new(
        name: "test", dns_name: "example.com.", visibility: "internal"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with name_servers output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_dns_managed_zone(:ref_test, { name: "ref-zone", dns_name: "ref.example.com." })
    end
    expect(ref.type).to eq('google_dns_managed_zone')
    expect(ref.outputs[:name_servers]).to eq("${google_dns_managed_zone.ref_test.name_servers}")
  end
end
