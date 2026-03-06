# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'

RSpec.describe 'cross-resource synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it 'synthesizes multiple resources in a single configuration' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google

      network_ref = google_compute_network(:vpc, { name: "main-vpc", auto_create_subnetworks: false })
      subnet_ref = google_compute_subnetwork(:subnet, {
        name: "main-subnet",
        region: "us-central1",
        network: network_ref.outputs[:self_link],
        ip_cidr_range: "10.0.0.0/24"
      })
      google_compute_firewall(:allow_ssh, {
        name: "allow-ssh",
        network: network_ref.outputs[:self_link],
        allow: [{ protocol: "tcp", ports: ["22"] }],
        source_ranges: ["0.0.0.0/0"]
      })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_compute_network][:vpc]).to be_a(Hash)
    expect(result[:resource][:google_compute_subnetwork][:subnet]).to be_a(Hash)
    expect(result[:resource][:google_compute_firewall][:allow_ssh]).to be_a(Hash)

    # Verify resource references are embedded as interpolation strings
    subnet = result[:resource][:google_compute_subnetwork][:subnet]
    expect(subnet[:network]).to eq("${google_compute_network.vpc.self_link}")
  end

  it 'synthesizes a GKE cluster with service account and IAM binding' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google

      sa_ref = google_service_account(:gke_sa, {
        account_id: "gke-nodes-sa",
        display_name: "GKE Node Service Account"
      })
      google_project_iam_member(:gke_sa_logging, {
        project: "my-project",
        role: "roles/logging.logWriter",
        member: "serviceAccount:${google_service_account.gke_sa.email}"
      })
      google_container_cluster(:cluster, {
        name: "app-cluster",
        location: "us-central1",
        initial_node_count: 1,
        remove_default_node_pool: true
      })
      google_container_node_pool(:primary, {
        name: "primary-pool",
        location: "us-central1",
        cluster: "${google_container_cluster.cluster.name}",
        node_count: 3,
        node_config: {
          machine_type: "e2-standard-4",
          service_account: sa_ref.outputs[:email]
        }
      })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_service_account][:gke_sa]).to be_a(Hash)
    expect(result[:resource][:google_project_iam_member][:gke_sa_logging]).to be_a(Hash)
    expect(result[:resource][:google_container_cluster][:cluster]).to be_a(Hash)
    expect(result[:resource][:google_container_node_pool][:primary]).to be_a(Hash)
  end

  it 'synthesizes a Cloud SQL setup with database and user' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google

      db_instance_ref = google_sql_database_instance(:main, {
        name: "app-db",
        region: "us-central1",
        database_version: "POSTGRES_15",
        settings: { tier: "db-custom-2-8192" }
      })
      google_sql_database(:app_db, {
        name: "app",
        instance: "${google_sql_database_instance.main.name}"
      })
      google_sql_user(:app_user, {
        name: "app-user",
        instance: "${google_sql_database_instance.main.name}",
        password: "secure-password"
      })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_sql_database_instance][:main]).to be_a(Hash)
    expect(result[:resource][:google_sql_database][:app_db]).to be_a(Hash)
    expect(result[:resource][:google_sql_user][:app_user]).to be_a(Hash)

    db = result[:resource][:google_sql_database][:app_db]
    expect(db[:instance]).to eq("${google_sql_database_instance.main.name}")
  end

  it 'synthesizes secret manager secret with version' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google

      secret_ref = google_secret_manager_secret(:api_key, {
        secret_id: "api-key",
        replication: { automatic: true }
      })
      google_secret_manager_secret_version(:v1, {
        secret: secret_ref.outputs[:id],
        secret_data: "sk-12345"
      })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_secret_manager_secret][:api_key]).to be_a(Hash)
    expect(result[:resource][:google_secret_manager_secret_version][:v1]).to be_a(Hash)

    version = result[:resource][:google_secret_manager_secret_version][:v1]
    expect(version[:secret]).to eq("${google_secret_manager_secret.api_key.id}")
  end

  it 'synthesizes storage bucket with IAM member' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google

      bucket_ref = google_storage_bucket(:assets, {
        name: "assets-bucket-unique",
        location: "US",
        uniform_bucket_level_access: true
      })
      google_storage_bucket_iam_member(:viewer, {
        bucket: "${google_storage_bucket.assets.name}",
        role: "roles/storage.objectViewer",
        member: "allUsers"
      })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_storage_bucket][:assets]).to be_a(Hash)
    expect(result[:resource][:google_storage_bucket_iam_member][:viewer]).to be_a(Hash)
  end

  it 'synthesizes pub/sub topic with subscription' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google

      topic_ref = google_pubsub_topic(:events, { name: "events" })
      google_pubsub_subscription(:events_sub, {
        name: "events-subscription",
        topic: topic_ref.outputs[:id],
        ack_deadline_seconds: 20
      })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_pubsub_topic][:events]).to be_a(Hash)
    expect(result[:resource][:google_pubsub_subscription][:events_sub]).to be_a(Hash)

    sub = result[:resource][:google_pubsub_subscription][:events_sub]
    expect(sub[:topic]).to eq("${google_pubsub_topic.events.id}")
  end
end
