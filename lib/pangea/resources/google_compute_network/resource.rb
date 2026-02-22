# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_network/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeNetwork
    def google_compute_network(name, attributes = {})
      attrs = Google::Types::ComputeNetworkAttributes.new(attributes)
      resource(:google_compute_network, name) do
        name attrs.name
        project attrs.project if attrs.project
        auto_create_subnetworks attrs.auto_create_subnetworks if !attrs.auto_create_subnetworks.nil?
        routing_mode attrs.routing_mode if attrs.routing_mode
        description attrs.description if attrs.description
        mtu attrs.mtu if attrs.mtu
        delete_default_routes_on_create attrs.delete_default_routes_on_create if !attrs.delete_default_routes_on_create.nil?
      end
      ResourceReference.new(
        type: 'google_compute_network',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_compute_network.#{name}.id}", self_link: "${google_compute_network.#{name}.self_link}" }
      )
    end
  end
  module Google
    include GoogleComputeNetwork
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
