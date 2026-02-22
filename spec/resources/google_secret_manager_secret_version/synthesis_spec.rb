# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_secret_manager_secret_version/resource'

RSpec.describe 'google_secret_manager_secret_version synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_secret_manager_secret_version(:test, { secret: "projects/my-project/secrets/my-secret", secret_data: "super-secret-value" })
      end
    }.synthesis
    expect(result[:resource][:google_secret_manager_secret_version][:test]).to be_a(Hash)
  end
end
