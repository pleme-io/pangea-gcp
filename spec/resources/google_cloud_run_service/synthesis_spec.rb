# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_cloud_run_service/resource'

RSpec.describe 'google_cloud_run_service synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_cloud_run_service(:test, { name: "my-service", location: "us-central1", template: { spec: { containers: [{ image: "gcr.io/my-project/my-image" }] } } })
      end
    }.synthesis
    expect(result[:resource][:google_cloud_run_service][:test]).to be_a(Hash)
  end
end
