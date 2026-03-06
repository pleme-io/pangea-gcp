# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_address/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeAddress
    include Pangea::Resources::ResourceBuilder

    define_resource :google_compute_address,
      attributes_class: Google::Types::ComputeAddressAttributes,
      outputs: { id: :id, address: :address, self_link: :self_link },
      map: [:name],
      map_present: [:project, :region, :address_type, :description, :address, :subnetwork, :network_tier],
      labels: :labels
  end
  module Google
    include GoogleComputeAddress
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
