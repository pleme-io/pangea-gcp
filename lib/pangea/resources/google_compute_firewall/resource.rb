# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_firewall/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeFirewall
    include Pangea::Resources::ResourceBuilder

    define_resource :google_compute_firewall,
      attributes_class: Google::Types::ComputeFirewallAttributes,
      outputs: { id: :id, self_link: :self_link },
      map: [:name, :network],
      map_present: [:project, :description, :direction, :priority, :allow, :deny, :source_ranges, :destination_ranges, :source_tags, :target_tags, :source_service_accounts, :target_service_accounts],
      map_bool: [:disabled]
  end
  module Google
    include GoogleComputeFirewall
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
