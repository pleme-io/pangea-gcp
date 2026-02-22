# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_secret_manager_secret_version/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSecretManagerSecretVersion
    def google_secret_manager_secret_version(name, attributes = {})
      attrs = Google::Types::SecretManagerSecretVersionAttributes.new(attributes)
      resource(:google_secret_manager_secret_version, name) do
        secret attrs.secret
        secret_data attrs.secret_data
        enabled attrs.enabled if !attrs.enabled.nil?
        deletion_policy attrs.deletion_policy if attrs.deletion_policy
      end
      ResourceReference.new(
        type: 'google_secret_manager_secret_version',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_secret_manager_secret_version.#{name}.id}", name: "${google_secret_manager_secret_version.#{name}.name}", version: "${google_secret_manager_secret_version.#{name}.version}" }
      )
    end
  end
  module Google
    include GoogleSecretManagerSecretVersion
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
