# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_instance/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeInstance
    include Pangea::Resources::ResourceBuilder

    define_resource :google_compute_instance,
      attributes_class: Google::Types::ComputeInstanceAttributes,
      outputs: { id: :id, instance_id: :instance_id, self_link: :self_link },
      map: [:name, :zone, :machine_type, :boot_disk, :network_interface],
      map_present: [:project, :description, :tags, :metadata, :metadata_startup_script, :service_account, :scheduling],
      map_bool: [:allow_stopping_for_update, :deletion_protection],
      labels: :labels
  end
  module Google
    include GoogleComputeInstance
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
