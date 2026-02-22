# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_container_node_pool/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleContainerNodePool
    def google_container_node_pool(name, attributes = {})
      attrs = Google::Types::ContainerNodePoolAttributes.new(attributes)
      resource(:google_container_node_pool, name) do
        name attrs.name
        project attrs.project if attrs.project
        location attrs.location
        cluster attrs.cluster
        node_count attrs.node_count if attrs.node_count
        node_config attrs.node_config if attrs.node_config
        autoscaling attrs.autoscaling if attrs.autoscaling
        management attrs.management if attrs.management
        max_pods_per_node attrs.max_pods_per_node if attrs.max_pods_per_node
        node_locations attrs.node_locations if attrs.node_locations
        upgrade_settings attrs.upgrade_settings if attrs.upgrade_settings
      end
      ResourceReference.new(
        type: 'google_container_node_pool',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_container_node_pool.#{name}.id}", instance_group_urls: "${google_container_node_pool.#{name}.instance_group_urls}" }
      )
    end
  end
  module Google
    include GoogleContainerNodePool
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
