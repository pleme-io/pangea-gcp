# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_sql_database/resource'

RSpec.describe 'google_sql_database synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_sql_database,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-db', instance: 'test-instance' },
    expected_outputs: [:id, :self_link]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_database(:test, { name: "my-database", instance: "my-db-instance" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_sql_database][:test]).to be_a(Hash)
  end

  it 'synthesizes with charset and collation' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_database(:full, {
        name: "app-db",
        project: "my-project",
        instance: "prod-instance",
        charset: "UTF8",
        collation: "en_US.UTF8"
      })
    end
    result = synthesizer.synthesis
    db = result[:resource][:google_sql_database][:full]
    expect(db[:charset]).to eq("UTF8")
    expect(db[:collation]).to eq("en_US.UTF8")
  end

  it 'returns a ResourceReference with correct outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_sql_database(:ref_test, { name: "ref-db", instance: "inst" })
    end
    expect(ref.type).to eq('google_sql_database')
    expect(ref.outputs[:self_link]).to eq("${google_sql_database.ref_test.self_link}")
  end
end
