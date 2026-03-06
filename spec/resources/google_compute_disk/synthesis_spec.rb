# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_disk/resource'

RSpec.describe 'google_compute_disk synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_compute_disk,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-disk', zone: 'us-central1-a' },
    expected_outputs: [:id, :self_link]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_disk(:test, { name: "my-disk", zone: "us-central1-a", size: 50, type: "pd-ssd" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_compute_disk][:test]).to be_a(Hash)
  end

  it 'synthesizes with image and labels' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_disk(:full, {
        name: "boot-disk",
        project: "my-project",
        zone: "us-east1-b",
        size: 200,
        type: "pd-balanced",
        image: "debian-cloud/debian-11",
        description: "Boot disk for web server",
        labels: { "tier" => "web", "env" => "prod" },
        physical_block_size_bytes: 4096
      })
    end
    result = synthesizer.synthesis
    disk = result[:resource][:google_compute_disk][:full]
    expect(disk[:size]).to eq(200)
    expect(disk[:image]).to eq("debian-cloud/debian-11")
    expect(disk[:physical_block_size_bytes]).to eq(4096)
  end

  it 'synthesizes with snapshot source' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_disk(:from_snap, {
        name: "restored-disk",
        zone: "us-central1-a",
        snapshot: "projects/my-project/global/snapshots/my-snapshot"
      })
    end
    result = synthesizer.synthesis
    disk = result[:resource][:google_compute_disk][:from_snap]
    expect(disk[:snapshot]).to eq("projects/my-project/global/snapshots/my-snapshot")
  end

  it 'returns a ResourceReference with correct outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_compute_disk(:ref_test, { name: "ref-disk", zone: "us-central1-a" })
    end
    expect(ref.type).to eq('google_compute_disk')
    expect(ref.outputs[:id]).to eq("${google_compute_disk.ref_test.id}")
    expect(ref.outputs[:self_link]).to eq("${google_compute_disk.ref_test.self_link}")
  end
end
