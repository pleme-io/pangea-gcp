# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_secret_manager_secret/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSecretManagerSecret
    include Pangea::Resources::ResourceBuilder

    define_resource :google_secret_manager_secret,
      attributes_class: Google::Types::SecretManagerSecretAttributes,
      outputs: { id: :id, name: :name },
      map: [:secret_id, :replication],
      map_present: [:project, :expire_time, :ttl, :rotation, :topics],
      labels: :labels
  end
  module Google
    include GoogleSecretManagerSecret
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
