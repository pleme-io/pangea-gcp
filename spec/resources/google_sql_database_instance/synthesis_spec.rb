# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_sql_database_instance/resource'

RSpec.describe 'google_sql_database_instance synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_sql_database_instance(:test, { name: "my-db-instance", region: "us-central1", database_version: "POSTGRES_15", settings: { tier: "db-f1-micro" } })
      end
    }.synthesis
    expect(result[:resource][:google_sql_database_instance][:test]).to be_a(Hash)
  end
end
