# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_subnetwork/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeSubnetwork
    include Pangea::Resources::ResourceBuilder

    define_resource :google_compute_subnetwork,
      attributes_class: Google::Types::ComputeSubnetworkAttributes,
      outputs: { id: :id, self_link: :self_link, gateway_address: :gateway_address },
      map: [:name, :region, :network, :ip_cidr_range],
      map_present: [:project, :description, :secondary_ip_range],
      map_bool: [:private_ip_google_access]
  end
  module Google
    include GoogleComputeSubnetwork
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
