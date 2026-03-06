# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_sql_database_instance/resource'

RSpec.describe 'google_sql_database_instance synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_sql_database_instance,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-instance', region: 'us-central1', database_version: 'POSTGRES_15', settings: { tier: 'db-f1-micro' } },
    expected_outputs: [:id, :connection_name, :self_link, :ip_address]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_database_instance(:test, { name: "my-db-instance", region: "us-central1", database_version: "POSTGRES_15", settings: { tier: "db-f1-micro" } })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_sql_database_instance][:test]).to be_a(Hash)
  end

  it 'synthesizes with full settings and replica configuration' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_database_instance(:full, {
        name: "prod-postgres",
        project: "my-project",
        region: "us-central1",
        database_version: "POSTGRES_15",
        settings: {
          tier: "db-custom-4-16384",
          availability_type: "REGIONAL",
          disk_size: 100,
          disk_type: "PD_SSD",
          disk_autoresize: true,
          backup_configuration: {
            enabled: true,
            point_in_time_recovery_enabled: true,
            start_time: "03:00"
          },
          ip_configuration: {
            ipv4_enabled: false,
            private_network: "projects/my-project/global/networks/my-vpc",
            require_ssl: true
          },
          database_flags: [
            { name: "max_connections", value: "200" }
          ]
        },
        deletion_protection: true,
        root_password: "super-secret"
      })
    end
    result = synthesizer.synthesis
    db = result[:resource][:google_sql_database_instance][:full]
    expect(db[:database_version]).to eq("POSTGRES_15")
    expect(db[:deletion_protection]).to eq(true)
    expect(db[:root_password]).to eq("super-secret")
    expect(db[:settings]).to be_a(Hash)
  end

  it 'synthesizes replica instance' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_sql_database_instance(:replica, {
        name: "read-replica",
        region: "us-east1",
        database_version: "POSTGRES_15",
        settings: { tier: "db-custom-2-8192" },
        master_instance_name: "prod-postgres",
        replica_configuration: {
          failover_target: false
        }
      })
    end
    result = synthesizer.synthesis
    db = result[:resource][:google_sql_database_instance][:replica]
    expect(db[:master_instance_name]).to eq("prod-postgres")
    expect(db[:replica_configuration]).to be_a(Hash)
  end

  it 'returns a ResourceReference with connection_name and ip_address outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_sql_database_instance(:ref_test, { name: "ref-db", region: "us-central1", database_version: "POSTGRES_15", settings: { tier: "db-f1-micro" } })
    end
    expect(ref.type).to eq('google_sql_database_instance')
    expect(ref.outputs[:connection_name]).to eq("${google_sql_database_instance.ref_test.connection_name}")
    expect(ref.outputs[:ip_address]).to eq("${google_sql_database_instance.ref_test.ip_address}")
    expect(ref.outputs[:self_link]).to eq("${google_sql_database_instance.ref_test.self_link}")
  end
end
