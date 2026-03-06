# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_dns_record_set/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleDnsRecordSet
    include Pangea::Resources::ResourceBuilder

    define_resource :google_dns_record_set,
      attributes_class: Google::Types::DnsRecordSetAttributes,
      outputs: { id: :id },
      map: [:name, :managed_zone, :type],
      map_present: [:project, :ttl, :rrdatas, :routing_policy]
  end
  module Google
    include GoogleDnsRecordSet
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
