# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_subnetwork/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeSubnetwork
    def google_compute_subnetwork(name, attributes = {})
      attrs = Google::Types::ComputeSubnetworkAttributes.new(attributes)
      resource(:google_compute_subnetwork, name) do
        name attrs.name
        project attrs.project if attrs.project
        region attrs.region
        network attrs.network
        ip_cidr_range attrs.ip_cidr_range
        description attrs.description if attrs.description
        private_ip_google_access attrs.private_ip_google_access if !attrs.private_ip_google_access.nil?
        if attrs.secondary_ip_range
          secondary_ip_range attrs.secondary_ip_range
        end
      end
      ResourceReference.new(
        type: 'google_compute_subnetwork',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_compute_subnetwork.#{name}.id}", self_link: "${google_compute_subnetwork.#{name}.self_link}", gateway_address: "${google_compute_subnetwork.#{name}.gateway_address}" }
      )
    end
  end
  module Google
    include GoogleComputeSubnetwork
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
