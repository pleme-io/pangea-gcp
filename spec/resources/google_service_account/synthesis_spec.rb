# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_service_account/resource'

RSpec.describe 'google_service_account synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_service_account,
    provider: Pangea::Resources::Google,
    required_attrs: { account_id: 'test-sa' },
    expected_outputs: [:id, :email, :unique_id]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_service_account(:test, { account_id: "my-service-account", display_name: "My Service Account" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_service_account][:test]).to be_a(Hash)
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_service_account(:full, {
        account_id: "app-sa",
        project: "my-project",
        display_name: "Application Service Account",
        description: "Used by the application to access GCS and Cloud SQL",
        disabled: false
      })
    end
    result = synthesizer.synthesis
    sa = result[:resource][:google_service_account][:full]
    expect(sa[:account_id]).to eq("app-sa")
    expect(sa[:description]).to eq("Used by the application to access GCS and Cloud SQL")
    expect(sa[:disabled]).to eq(false)
  end

  it 'synthesizes disabled service account' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_service_account(:disabled, {
        account_id: "deprecated-sa",
        disabled: true
      })
    end
    result = synthesizer.synthesis
    sa = result[:resource][:google_service_account][:disabled]
    expect(sa[:disabled]).to eq(true)
  end

  it 'returns a ResourceReference with email and unique_id outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_service_account(:ref_test, { account_id: "ref-sa" })
    end
    expect(ref.type).to eq('google_service_account')
    expect(ref.outputs[:email]).to eq("${google_service_account.ref_test.email}")
    expect(ref.outputs[:unique_id]).to eq("${google_service_account.ref_test.unique_id}")
  end
end
