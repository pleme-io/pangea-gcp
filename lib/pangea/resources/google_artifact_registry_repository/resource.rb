# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_artifact_registry_repository/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleArtifactRegistryRepository
    include Pangea::Resources::ResourceBuilder

    define_resource :google_artifact_registry_repository,
      attributes_class: Google::Types::ArtifactRegistryRepositoryAttributes,
      outputs: { id: :id, name: :name },
      map: [:repository_id, :location, :format],
      map_present: [:project, :description, :kms_key_name, :mode, :cleanup_policies, :docker_config, :maven_config],
      map_bool: [:cleanup_policy_dry_run],
      labels: :labels
  end
  module Google
    include GoogleArtifactRegistryRepository
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
