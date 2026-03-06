# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_project/resource'

RSpec.describe 'google_project synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_project,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'Test Project', project_id: 'test-project-id' },
    expected_outputs: [:id, :number]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_project(:test, { name: "My Project", project_id: "my-project-123456" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_project][:test]).to be_a(Hash)
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_project(:full, {
        name: "Production Project",
        project_id: "prod-project-abc",
        org_id: "123456789",
        billing_account: "01ABCD-EFGH23-456789",
        folder_id: "987654321",
        auto_create_network: false,
        labels: { "env" => "production", "team" => "platform" }
      })
    end
    result = synthesizer.synthesis
    project = result[:resource][:google_project][:full]
    expect(project[:name]).to eq("Production Project")
    expect(project[:project_id]).to eq("prod-project-abc")
    expect(project[:org_id]).to eq("123456789")
    expect(project[:auto_create_network]).to eq(false)
    expect(project[:labels]).to eq({ "env" => "production", "team" => "platform" })
  end

  it 'returns a ResourceReference with number output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_project(:ref_test, { name: "Ref Project", project_id: "ref-proj-123456" })
    end
    expect(ref.type).to eq('google_project')
    expect(ref.outputs[:id]).to eq("${google_project.ref_test.id}")
    expect(ref.outputs[:number]).to eq("${google_project.ref_test.number}")
  end
end
