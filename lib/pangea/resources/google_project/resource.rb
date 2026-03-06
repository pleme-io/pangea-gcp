# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_project/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleProject
    include Pangea::Resources::ResourceBuilder

    define_resource :google_project,
      attributes_class: Google::Types::ProjectAttributes,
      outputs: { id: :id, number: :number },
      map: [:name, :project_id],
      map_present: [:org_id, :billing_account, :folder_id],
      map_bool: [:auto_create_network],
      labels: :labels
  end
  module Google
    include GoogleProject
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
