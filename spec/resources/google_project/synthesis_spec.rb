# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_project/resource'

RSpec.describe 'google_project synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_project(:test, { name: "My Project", project_id: "my-project-123456" })
      end
    }.synthesis
    expect(result[:resource][:google_project][:test]).to be_a(Hash)
  end
end
