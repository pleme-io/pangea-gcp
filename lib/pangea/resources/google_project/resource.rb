# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_project/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleProject
    def google_project(name, attributes = {})
      attrs = Google::Types::ProjectAttributes.new(attributes)
      resource(:google_project, name) do
        name attrs.name
        project_id attrs.project_id
        org_id attrs.org_id if attrs.org_id
        billing_account attrs.billing_account if attrs.billing_account
        folder_id attrs.folder_id if attrs.folder_id
        auto_create_network attrs.auto_create_network if !attrs.auto_create_network.nil?
        labels attrs.labels if attrs.labels.any?
      end
      ResourceReference.new(
        type: 'google_project',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_project.#{name}.id}", number: "${google_project.#{name}.number}" }
      )
    end
  end
  module Google
    include GoogleProject
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
