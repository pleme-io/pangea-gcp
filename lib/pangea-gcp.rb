# frozen_string_literal: true

require 'pangea-core'
require 'terraform-synthesizer'

# Google Cloud types
require_relative 'pangea/resources/types/google/core'

# Google Cloud resources
require_relative 'pangea/resources/google_project/resource'
require_relative 'pangea/resources/google_compute_network/resource'
require_relative 'pangea/resources/google_compute_subnetwork/resource'
require_relative 'pangea/resources/google_compute_firewall/resource'
require_relative 'pangea/resources/google_compute_instance/resource'
require_relative 'pangea/resources/google_compute_address/resource'
require_relative 'pangea/resources/google_compute_disk/resource'
require_relative 'pangea/resources/google_storage_bucket/resource'
require_relative 'pangea/resources/google_storage_bucket_iam_member/resource'
require_relative 'pangea/resources/google_container_cluster/resource'
require_relative 'pangea/resources/google_container_node_pool/resource'
require_relative 'pangea/resources/google_sql_database_instance/resource'
require_relative 'pangea/resources/google_sql_database/resource'
require_relative 'pangea/resources/google_sql_user/resource'
require_relative 'pangea/resources/google_dns_managed_zone/resource'
require_relative 'pangea/resources/google_dns_record_set/resource'
require_relative 'pangea/resources/google_pubsub_topic/resource'
require_relative 'pangea/resources/google_pubsub_subscription/resource'
require_relative 'pangea/resources/google_cloud_run_service/resource'
require_relative 'pangea/resources/google_service_account/resource'
require_relative 'pangea/resources/google_project_iam_member/resource'
require_relative 'pangea/resources/google_secret_manager_secret/resource'
require_relative 'pangea/resources/google_secret_manager_secret_version/resource'
require_relative 'pangea/resources/google_redis_instance/resource'
require_relative 'pangea/resources/google_artifact_registry_repository/resource'

# Google Cloud module aggregator
require_relative 'pangea/resources/google'
