# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_firewall/resource'

RSpec.describe 'google_compute_firewall synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_compute_firewall,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-fw', network: 'default' },
    expected_outputs: [:id, :self_link]

  it 'synthesizes with allow rules' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_firewall(:test, { name: "allow-ssh", network: "my-network", allow: [{ protocol: "tcp", ports: ["22"] }], source_ranges: ["0.0.0.0/0"] })
    end
    result = synthesizer.synthesis
    fw = result[:resource][:google_compute_firewall][:test]
    expect(fw).to be_a(Hash)
    expect(fw[:name]).to eq("allow-ssh")
    expect(fw[:network]).to eq("my-network")
  end

  it 'synthesizes with deny rules and egress direction' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_firewall(:deny_egress, {
        name: "deny-egress",
        network: "my-network",
        direction: "EGRESS",
        deny: [{ protocol: "all" }],
        destination_ranges: ["10.0.0.0/8"],
        priority: 1000,
        disabled: false
      })
    end
    result = synthesizer.synthesis
    fw = result[:resource][:google_compute_firewall][:deny_egress]
    expect(fw[:direction]).to eq("EGRESS")
    expect(fw[:priority]).to eq(1000)
    expect(fw[:disabled]).to eq(false)
  end

  it 'rejects invalid direction enum value' do
    expect {
      Google::Types::ComputeFirewallAttributes.new(
        name: "test", network: "net", direction: "BOTH"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'synthesizes with service account filtering' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_firewall(:sa_rule, {
        name: "sa-based-rule",
        network: "my-network",
        direction: "INGRESS",
        allow: [{ protocol: "tcp", ports: ["443"] }],
        source_service_accounts: ["sa@project.iam.gserviceaccount.com"],
        target_service_accounts: ["target-sa@project.iam.gserviceaccount.com"]
      })
    end
    result = synthesizer.synthesis
    fw = result[:resource][:google_compute_firewall][:sa_rule]
    expect(fw[:source_service_accounts]).to eq(["sa@project.iam.gserviceaccount.com"])
    expect(fw[:target_service_accounts]).to eq(["target-sa@project.iam.gserviceaccount.com"])
  end

  it 'returns a ResourceReference with correct outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_compute_firewall(:ref_test, { name: "ref-fw", network: "net" })
    end
    expect(ref.type).to eq('google_compute_firewall')
    expect(ref.outputs[:id]).to eq("${google_compute_firewall.ref_test.id}")
    expect(ref.outputs[:self_link]).to eq("${google_compute_firewall.ref_test.self_link}")
  end
end
