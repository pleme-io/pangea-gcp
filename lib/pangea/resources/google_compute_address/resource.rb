# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_address/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeAddress
    def google_compute_address(name, attributes = {})
      attrs = Google::Types::ComputeAddressAttributes.new(attributes)
      resource(:google_compute_address, name) do
        name attrs.name
        project attrs.project if attrs.project
        region attrs.region if attrs.region
        address_type attrs.address_type if attrs.address_type
        description attrs.description if attrs.description
        address attrs.address if attrs.address
        subnetwork attrs.subnetwork if attrs.subnetwork
        network_tier attrs.network_tier if attrs.network_tier
        labels attrs.labels if attrs.labels.any?
      end
      ResourceReference.new(
        type: 'google_compute_address',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_compute_address.#{name}.id}", address: "${google_compute_address.#{name}.address}", self_link: "${google_compute_address.#{name}.self_link}" }
      )
    end
  end
  module Google
    include GoogleComputeAddress
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
