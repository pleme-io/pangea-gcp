# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_artifact_registry_repository/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleArtifactRegistryRepository
    def google_artifact_registry_repository(name, attributes = {})
      attrs = Google::Types::ArtifactRegistryRepositoryAttributes.new(attributes)
      resource(:google_artifact_registry_repository, name) do
        repository_id attrs.repository_id
        project attrs.project if attrs.project
        location attrs.location
        format attrs.format
        description attrs.description if attrs.description
        labels attrs.labels if attrs.labels.any?
        kms_key_name attrs.kms_key_name if attrs.kms_key_name
        mode attrs.mode if attrs.mode
        cleanup_policy_dry_run attrs.cleanup_policy_dry_run if !attrs.cleanup_policy_dry_run.nil?
        cleanup_policies attrs.cleanup_policies if attrs.cleanup_policies
        docker_config attrs.docker_config if attrs.docker_config
        maven_config attrs.maven_config if attrs.maven_config
      end
      ResourceReference.new(
        type: 'google_artifact_registry_repository',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_artifact_registry_repository.#{name}.id}", name: "${google_artifact_registry_repository.#{name}.name}" }
      )
    end
  end
  module Google
    include GoogleArtifactRegistryRepository
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
