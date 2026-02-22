# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_artifact_registry_repository/resource'

RSpec.describe 'google_artifact_registry_repository synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_artifact_registry_repository(:test, { repository_id: "my-repo", location: "us-central1", format: "DOCKER", description: "Docker images" })
      end
    }.synthesis
    expect(result[:resource][:google_artifact_registry_repository][:test]).to be_a(Hash)
  end
end
