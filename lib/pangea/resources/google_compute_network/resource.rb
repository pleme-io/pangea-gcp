# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_network/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeNetwork
    include Pangea::Resources::ResourceBuilder

    define_resource :google_compute_network,
      attributes_class: Google::Types::ComputeNetworkAttributes,
      outputs: { id: :id, self_link: :self_link },
      map: [:name],
      map_present: [:project, :routing_mode, :description, :mtu],
      map_bool: [:auto_create_subnetworks, :delete_default_routes_on_create]
  end
  module Google
    include GoogleComputeNetwork
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
