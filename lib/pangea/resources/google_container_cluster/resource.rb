# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_container_cluster/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleContainerCluster
    include Pangea::Resources::ResourceBuilder

    define_resource :google_container_cluster,
      attributes_class: Google::Types::ContainerClusterAttributes,
      outputs: { id: :id, endpoint: :endpoint, master_version: :master_version, self_link: :self_link },
      map: [:name, :location],
      map_present: [:project, :initial_node_count, :network, :subnetwork, :description, :min_master_version, :networking_mode, :ip_allocation_policy, :private_cluster_config, :master_auth, :workload_identity_config, :release_channel],
      map_bool: [:remove_default_node_pool, :deletion_protection],
      labels: :resource_labels
  end
  module Google
    include GoogleContainerCluster
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
