# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_service_account/resource'

RSpec.describe 'google_service_account synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_service_account(:test, { account_id: "my-service-account", display_name: "My Service Account" })
      end
    }.synthesis
    expect(result[:resource][:google_service_account][:test]).to be_a(Hash)
  end
end
