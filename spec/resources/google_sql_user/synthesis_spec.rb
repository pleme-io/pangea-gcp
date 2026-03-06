# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_sql_user/resource'

RSpec.describe 'google_sql_user synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_sql_user,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-user', instance: 'test-instance' },
    expected_outputs: [:id]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_user(:test, { name: "app-user", instance: "my-db-instance", password: "secret123" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_sql_user][:test]).to be_a(Hash)
  end

  it 'synthesizes with IAM user type' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_user(:iam_user, {
        name: "sa@my-project.iam.gserviceaccount.com",
        instance: "prod-instance",
        type: "CLOUD_IAM_SERVICE_ACCOUNT",
        deletion_policy: "ABANDON"
      })
    end
    result = synthesizer.synthesis
    user = result[:resource][:google_sql_user][:iam_user]
    expect(user[:type]).to eq("CLOUD_IAM_SERVICE_ACCOUNT")
    expect(user[:deletion_policy]).to eq("ABANDON")
  end

  it 'rejects invalid user type enum value' do
    expect {
      Google::Types::SqlUserAttributes.new(
        name: "test", instance: "inst", type: "INVALID_TYPE"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'synthesizes with host restriction' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_user(:hosted, {
        name: "external-user",
        instance: "mysql-instance",
        password: "pass123",
        host: "%"
      })
    end
    result = synthesizer.synthesis
    user = result[:resource][:google_sql_user][:hosted]
    expect(user[:host]).to eq("%")
  end
end
