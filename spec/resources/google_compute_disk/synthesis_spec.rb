# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_disk/resource'

RSpec.describe 'google_compute_disk synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_compute_disk(:test, { name: "my-disk", zone: "us-central1-a", size: 50, type: "pd-ssd" })
      end
    }.synthesis
    expect(result[:resource][:google_compute_disk][:test]).to be_a(Hash)
  end
end
