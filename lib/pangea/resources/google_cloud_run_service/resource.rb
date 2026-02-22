# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_cloud_run_service/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleCloudRunService
    def google_cloud_run_service(name, attributes = {})
      attrs = Google::Types::CloudRunServiceAttributes.new(attributes)
      resource(:google_cloud_run_service, name) do
        name attrs.name
        project attrs.project if attrs.project
        location attrs.location
        template attrs.template
        traffic attrs.traffic if attrs.traffic
        metadata attrs.metadata if attrs.metadata
        autogenerate_revision_name attrs.autogenerate_revision_name if !attrs.autogenerate_revision_name.nil?
      end
      ResourceReference.new(
        type: 'google_cloud_run_service',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_cloud_run_service.#{name}.id}", status: "${google_cloud_run_service.#{name}.status}" }
      )
    end
  end
  module Google
    include GoogleCloudRunService
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
