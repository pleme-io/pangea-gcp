# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_compute_instance/resource'

RSpec.describe 'google_compute_instance synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_compute_instance,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-vm', zone: 'us-central1-a', machine_type: 'e2-micro', boot_disk: { initialize_params: { image: 'debian-11' } }, network_interface: { network: 'default' } },
    expected_outputs: [:id, :instance_id, :self_link]

  let(:minimal_attrs) do
    {
      name: "my-instance",
      zone: "us-central1-a",
      machine_type: "e2-micro",
      boot_disk: { initialize_params: { image: "debian-cloud/debian-11" } },
      network_interface: { network: "default" }
    }
  end

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_instance(:test, {
        name: "my-instance",
        zone: "us-central1-a",
        machine_type: "e2-micro",
        boot_disk: { initialize_params: { image: "debian-cloud/debian-11" } },
        network_interface: { network: "default" }
      })
    end
    result = synthesizer.synthesis
    instance = result[:resource][:google_compute_instance][:test]
    expect(instance).to be_a(Hash)
    expect(instance[:name]).to eq("my-instance")
    expect(instance[:zone]).to eq("us-central1-a")
    expect(instance[:machine_type]).to eq("e2-micro")
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_instance(:full, {
        name: "full-instance",
        project: "my-project-id",
        zone: "us-east1-b",
        machine_type: "n2-standard-4",
        boot_disk: { initialize_params: { image: "ubuntu-os-cloud/ubuntu-2204-lts", size: 50 } },
        network_interface: { network: "custom-vpc", subnetwork: "subnet-01" },
        description: "A fully configured instance",
        tags: ["web", "production"],
        labels: { "env" => "prod", "team" => "platform" },
        metadata: { "ssh-keys" => "user:ssh-rsa AAAA..." },
        metadata_startup_script: "#!/bin/bash\necho hello",
        service_account: { email: "sa@project.iam.gserviceaccount.com", scopes: ["cloud-platform"] },
        allow_stopping_for_update: true,
        deletion_protection: false,
        scheduling: { preemptible: true, automatic_restart: false }
      })
    end
    result = synthesizer.synthesis
    instance = result[:resource][:google_compute_instance][:full]
    expect(instance[:description]).to eq("A fully configured instance")
    expect(instance[:tags]).to eq(["web", "production"])
    expect(instance[:labels]).to eq({ "env" => "prod", "team" => "platform" })
    expect(instance[:allow_stopping_for_update]).to eq(true)
    expect(instance[:deletion_protection]).to eq(false)
  end

  it 'returns a ResourceReference with correct outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_compute_instance(:ref_test, {
        name: "ref-instance",
        zone: "us-central1-a",
        machine_type: "e2-micro",
        boot_disk: { initialize_params: { image: "debian-cloud/debian-11" } },
        network_interface: { network: "default" }
      })
    end
    expect(ref.type).to eq('google_compute_instance')
    expect(ref.name).to eq(:ref_test)
    expect(ref.outputs[:id]).to eq("${google_compute_instance.ref_test.id}")
    expect(ref.outputs[:instance_id]).to eq("${google_compute_instance.ref_test.instance_id}")
    expect(ref.outputs[:self_link]).to eq("${google_compute_instance.ref_test.self_link}")
  end

  it 'raises error when required name is missing' do
    expect {
      Google::Types::ComputeInstanceAttributes.new(
        zone: "us-central1-a",
        machine_type: "e2-micro",
        boot_disk: {},
        network_interface: {}
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'raises error when required zone is missing' do
    expect {
      Google::Types::ComputeInstanceAttributes.new(
        name: "test",
        machine_type: "e2-micro",
        boot_disk: {},
        network_interface: {}
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'omits nil optional attributes from synthesis output' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_compute_instance(:minimal, {
        name: "minimal-instance",
        zone: "us-central1-a",
        machine_type: "e2-micro",
        boot_disk: { initialize_params: { image: "debian-cloud/debian-11" } },
        network_interface: { network: "default" }
      })
    end
    result = synthesizer.synthesis
    instance = result[:resource][:google_compute_instance][:minimal]
    expect(instance).not_to have_key(:project)
    expect(instance).not_to have_key(:description)
    expect(instance).not_to have_key(:tags)
    expect(instance).not_to have_key(:metadata_startup_script)
    expect(instance).not_to have_key(:service_account)
    expect(instance).not_to have_key(:scheduling)
  end
end
