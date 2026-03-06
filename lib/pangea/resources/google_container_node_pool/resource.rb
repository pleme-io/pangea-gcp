# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_container_node_pool/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleContainerNodePool
    include Pangea::Resources::ResourceBuilder

    define_resource :google_container_node_pool,
      attributes_class: Google::Types::ContainerNodePoolAttributes,
      outputs: { id: :id, instance_group_urls: :instance_group_urls },
      map: [:name, :location, :cluster],
      map_present: [:project, :node_count, :node_config, :autoscaling, :management, :max_pods_per_node, :node_locations, :upgrade_settings]
  end
  module Google
    include GoogleContainerNodePool
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
