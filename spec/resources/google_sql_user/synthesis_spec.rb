# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_sql_user/resource'

RSpec.describe 'google_sql_user synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_sql_user(:test, { name: "app-user", instance: "my-db-instance", password: "secret123" })
      end
    }.synthesis
    expect(result[:resource][:google_sql_user][:test]).to be_a(Hash)
  end
end
