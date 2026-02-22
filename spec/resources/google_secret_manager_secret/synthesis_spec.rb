# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_secret_manager_secret/resource'

RSpec.describe 'google_secret_manager_secret synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_secret_manager_secret(:test, { secret_id: "my-secret", replication: { automatic: true } })
      end
    }.synthesis
    expect(result[:resource][:google_secret_manager_secret][:test]).to be_a(Hash)
  end
end
