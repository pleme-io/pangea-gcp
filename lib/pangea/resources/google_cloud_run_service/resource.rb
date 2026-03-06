# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_cloud_run_service/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleCloudRunService
    include Pangea::Resources::ResourceBuilder

    define_resource :google_cloud_run_service,
      attributes_class: Google::Types::CloudRunServiceAttributes,
      outputs: { id: :id, status: :status },
      map: [:name, :location, :template],
      map_present: [:project, :traffic, :metadata],
      map_bool: [:autogenerate_revision_name]
  end
  module Google
    include GoogleCloudRunService
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
