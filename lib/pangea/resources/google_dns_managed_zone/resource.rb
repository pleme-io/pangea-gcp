# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_dns_managed_zone/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleDnsManagedZone
    include Pangea::Resources::ResourceBuilder

    define_resource :google_dns_managed_zone,
      attributes_class: Google::Types::DnsManagedZoneAttributes,
      outputs: { id: :id, name_servers: :name_servers },
      map: [:name, :dns_name],
      map_present: [:project, :description, :visibility, :dnssec_config, :private_visibility_config],
      map_bool: [:force_destroy],
      labels: :labels
  end
  module Google
    include GoogleDnsManagedZone
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
