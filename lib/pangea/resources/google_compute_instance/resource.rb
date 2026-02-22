# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_instance/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeInstance
    def google_compute_instance(name, attributes = {})
      attrs = Google::Types::ComputeInstanceAttributes.new(attributes)
      resource(:google_compute_instance, name) do
        name attrs.name
        project attrs.project if attrs.project
        zone attrs.zone
        machine_type attrs.machine_type
        boot_disk attrs.boot_disk
        network_interface attrs.network_interface
        description attrs.description if attrs.description
        tags attrs.tags if attrs.tags
        labels attrs.labels if attrs.labels.any?
        metadata attrs.metadata if attrs.metadata
        metadata_startup_script attrs.metadata_startup_script if attrs.metadata_startup_script
        service_account attrs.service_account if attrs.service_account
        allow_stopping_for_update attrs.allow_stopping_for_update if !attrs.allow_stopping_for_update.nil?
        deletion_protection attrs.deletion_protection if !attrs.deletion_protection.nil?
        scheduling attrs.scheduling if attrs.scheduling
      end
      ResourceReference.new(
        type: 'google_compute_instance',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_compute_instance.#{name}.id}", instance_id: "${google_compute_instance.#{name}.instance_id}", self_link: "${google_compute_instance.#{name}.self_link}" }
      )
    end
  end
  module Google
    include GoogleComputeInstance
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
