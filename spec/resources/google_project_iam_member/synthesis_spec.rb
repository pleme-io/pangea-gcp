# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_project_iam_member/resource'

RSpec.describe 'google_project_iam_member synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_project_iam_member,
    provider: Pangea::Resources::Google,
    required_attrs: { project: 'test-project', role: 'roles/viewer', member: 'user:test@example.com' },
    expected_outputs: [:id]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_project_iam_member(:test, { project: "my-project", role: "roles/editor", member: "serviceAccount:sa@my-project.iam.gserviceaccount.com" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_project_iam_member][:test]).to be_a(Hash)
  end

  it 'synthesizes with IAM condition' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_project_iam_member(:conditional, {
        project: "prod-project",
        role: "roles/cloudsql.admin",
        member: "user:admin@example.com",
        condition: {
          title: "temporary_access",
          description: "Temporary access until end of sprint",
          expression: "request.time < timestamp('2026-03-01T00:00:00Z')"
        }
      })
    end
    result = synthesizer.synthesis
    iam = result[:resource][:google_project_iam_member][:conditional]
    expect(iam[:condition]).to be_a(Hash)
    expect(iam[:condition][:title]).to eq("temporary_access")
  end

  it 'raises error when required project is missing' do
    expect {
      Google::Types::ProjectIamMemberAttributes.new(
        role: "roles/editor",
        member: "user:test@example.com"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'raises error when required role is missing' do
    expect {
      Google::Types::ProjectIamMemberAttributes.new(
        project: "my-project",
        member: "user:test@example.com"
      )
    }.to raise_error(Dry::Struct::Error)
  end
end
