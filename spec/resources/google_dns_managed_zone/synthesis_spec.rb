# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_dns_managed_zone/resource'

RSpec.describe 'google_dns_managed_zone synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_dns_managed_zone(:test, { name: "my-zone", dns_name: "example.com.", description: "My DNS zone" })
      end
    }.synthesis
    expect(result[:resource][:google_dns_managed_zone][:test]).to be_a(Hash)
  end
end
