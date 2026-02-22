# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_instance/resource'

RSpec.describe 'google_compute_instance synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_compute_instance(:test, {
          name: "my-instance",
          zone: "us-central1-a",
          machine_type: "e2-micro",
          boot_disk: { initialize_params: { image: "debian-cloud/debian-11" } },
          network_interface: { network: "default" }
        })
      end
    }.synthesis
    expect(result[:resource][:google_compute_instance][:test]).to be_a(Hash)
  end
end
