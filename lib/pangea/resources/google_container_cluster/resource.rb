# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_container_cluster/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleContainerCluster
    def google_container_cluster(name, attributes = {})
      attrs = Google::Types::ContainerClusterAttributes.new(attributes)
      resource(:google_container_cluster, name) do
        name attrs.name
        project attrs.project if attrs.project
        location attrs.location
        initial_node_count attrs.initial_node_count if attrs.initial_node_count
        remove_default_node_pool attrs.remove_default_node_pool if !attrs.remove_default_node_pool.nil?
        network attrs.network if attrs.network
        subnetwork attrs.subnetwork if attrs.subnetwork
        description attrs.description if attrs.description
        min_master_version attrs.min_master_version if attrs.min_master_version
        deletion_protection attrs.deletion_protection if !attrs.deletion_protection.nil?
        networking_mode attrs.networking_mode if attrs.networking_mode
        ip_allocation_policy attrs.ip_allocation_policy if attrs.ip_allocation_policy
        private_cluster_config attrs.private_cluster_config if attrs.private_cluster_config
        master_auth attrs.master_auth if attrs.master_auth
        workload_identity_config attrs.workload_identity_config if attrs.workload_identity_config
        release_channel attrs.release_channel if attrs.release_channel
        resource_labels attrs.resource_labels if attrs.resource_labels.any?
      end
      ResourceReference.new(
        type: 'google_container_cluster',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_container_cluster.#{name}.id}", endpoint: "${google_container_cluster.#{name}.endpoint}", master_version: "${google_container_cluster.#{name}.master_version}", self_link: "${google_container_cluster.#{name}.self_link}" }
      )
    end
  end
  module Google
    include GoogleContainerCluster
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
