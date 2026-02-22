# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_secret_manager_secret/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSecretManagerSecret
    def google_secret_manager_secret(name, attributes = {})
      attrs = Google::Types::SecretManagerSecretAttributes.new(attributes)
      resource(:google_secret_manager_secret, name) do
        secret_id attrs.secret_id
        project attrs.project if attrs.project
        replication attrs.replication
        labels attrs.labels if attrs.labels.any?
        expire_time attrs.expire_time if attrs.expire_time
        ttl attrs.ttl if attrs.ttl
        rotation attrs.rotation if attrs.rotation
        topics attrs.topics if attrs.topics
      end
      ResourceReference.new(
        type: 'google_secret_manager_secret',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_secret_manager_secret.#{name}.id}", name: "${google_secret_manager_secret.#{name}.name}" }
      )
    end
  end
  module Google
    include GoogleSecretManagerSecret
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
