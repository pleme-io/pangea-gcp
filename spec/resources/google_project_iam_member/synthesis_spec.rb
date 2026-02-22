# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_project_iam_member/resource'

RSpec.describe 'google_project_iam_member synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_project_iam_member(:test, { project: "my-project", role: "roles/editor", member: "serviceAccount:sa@my-project.iam.gserviceaccount.com" })
      end
    }.synthesis
    expect(result[:resource][:google_project_iam_member][:test]).to be_a(Hash)
  end
end
