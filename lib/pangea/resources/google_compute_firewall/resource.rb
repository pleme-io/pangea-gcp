# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_firewall/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeFirewall
    def google_compute_firewall(name, attributes = {})
      attrs = Google::Types::ComputeFirewallAttributes.new(attributes)
      resource(:google_compute_firewall, name) do
        name attrs.name
        project attrs.project if attrs.project
        network attrs.network
        description attrs.description if attrs.description
        direction attrs.direction if attrs.direction
        priority attrs.priority if attrs.priority
        allow attrs.allow if attrs.allow
        deny attrs.deny if attrs.deny
        source_ranges attrs.source_ranges if attrs.source_ranges
        destination_ranges attrs.destination_ranges if attrs.destination_ranges
        source_tags attrs.source_tags if attrs.source_tags
        target_tags attrs.target_tags if attrs.target_tags
        source_service_accounts attrs.source_service_accounts if attrs.source_service_accounts
        target_service_accounts attrs.target_service_accounts if attrs.target_service_accounts
        disabled attrs.disabled if !attrs.disabled.nil?
      end
      ResourceReference.new(
        type: 'google_compute_firewall',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_compute_firewall.#{name}.id}", self_link: "${google_compute_firewall.#{name}.self_link}" }
      )
    end
  end
  module Google
    include GoogleComputeFirewall
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
