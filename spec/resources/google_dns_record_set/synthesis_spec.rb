# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_dns_record_set/resource'

RSpec.describe 'google_dns_record_set synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_dns_record_set(:test, { name: "www.example.com.", managed_zone: "my-zone", type: "A", ttl: 300, rrdatas: ["192.0.2.1"] })
      end
    }.synthesis
    expect(result[:resource][:google_dns_record_set][:test]).to be_a(Hash)
  end
end
