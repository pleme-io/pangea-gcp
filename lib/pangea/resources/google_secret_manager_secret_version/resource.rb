# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_secret_manager_secret_version/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSecretManagerSecretVersion
    include Pangea::Resources::ResourceBuilder

    define_resource :google_secret_manager_secret_version,
      attributes_class: Google::Types::SecretManagerSecretVersionAttributes,
      outputs: { id: :id, name: :name, version: :version },
      map: [:secret, :secret_data],
      map_present: [:deletion_policy],
      map_bool: [:enabled]
  end
  module Google
    include GoogleSecretManagerSecretVersion
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
