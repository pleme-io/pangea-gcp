# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_dns_record_set/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleDnsRecordSet
    def google_dns_record_set(name, attributes = {})
      attrs = Google::Types::DnsRecordSetAttributes.new(attributes)
      resource(:google_dns_record_set, name) do
        name attrs.name
        project attrs.project if attrs.project
        managed_zone attrs.managed_zone
        type attrs.type
        ttl attrs.ttl if attrs.ttl
        rrdatas attrs.rrdatas if attrs.rrdatas
        routing_policy attrs.routing_policy if attrs.routing_policy
      end
      ResourceReference.new(
        type: 'google_dns_record_set',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_dns_record_set.#{name}.id}" }
      )
    end
  end
  module Google
    include GoogleDnsRecordSet
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
