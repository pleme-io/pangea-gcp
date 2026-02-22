# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_dns_managed_zone/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleDnsManagedZone
    def google_dns_managed_zone(name, attributes = {})
      attrs = Google::Types::DnsManagedZoneAttributes.new(attributes)
      resource(:google_dns_managed_zone, name) do
        name attrs.name
        project attrs.project if attrs.project
        dns_name attrs.dns_name
        description attrs.description if attrs.description
        visibility attrs.visibility if attrs.visibility
        dnssec_config attrs.dnssec_config if attrs.dnssec_config
        private_visibility_config attrs.private_visibility_config if attrs.private_visibility_config
        labels attrs.labels if attrs.labels.any?
        force_destroy attrs.force_destroy if !attrs.force_destroy.nil?
      end
      ResourceReference.new(
        type: 'google_dns_managed_zone',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_dns_managed_zone.#{name}.id}", name_servers: "${google_dns_managed_zone.#{name}.name_servers}" }
      )
    end
  end
  module Google
    include GoogleDnsManagedZone
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
