# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_dns_record_set/resource'

RSpec.describe 'google_dns_record_set synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_dns_record_set,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test.example.com.', managed_zone: 'test-zone', type: 'A' },
    expected_outputs: [:id]

  it 'synthesizes A record' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_dns_record_set(:test, { name: "www.example.com.", managed_zone: "my-zone", type: "A", ttl: 300, rrdatas: ["192.0.2.1"] })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_dns_record_set][:test]).to be_a(Hash)
  end

  it 'synthesizes CNAME record with routing policy' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_dns_record_set(:weighted, {
        name: "api.example.com.",
        project: "my-project",
        managed_zone: "my-zone",
        type: "A",
        routing_policy: {
          wrr: [
            { weight: 0.8, rrdatas: ["10.0.0.1"] },
            { weight: 0.2, rrdatas: ["10.0.0.2"] }
          ]
        }
      })
    end
    result = synthesizer.synthesis
    record = result[:resource][:google_dns_record_set][:weighted]
    expect(record[:routing_policy]).to be_a(Hash)
    expect(record[:routing_policy][:wrr]).to be_a(Array)
  end

  it 'raises error when required managed_zone is missing' do
    expect {
      Google::Types::DnsRecordSetAttributes.new(
        name: "test.example.com.", type: "A"
      )
    }.to raise_error(Dry::Struct::Error)
  end
end
