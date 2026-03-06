# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_service_account/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleServiceAccount
    include Pangea::Resources::ResourceBuilder

    define_resource :google_service_account,
      attributes_class: Google::Types::ServiceAccountAttributes,
      outputs: { id: :id, email: :email, unique_id: :unique_id },
      map: [:account_id],
      map_present: [:project, :display_name, :description],
      map_bool: [:disabled]
  end
  module Google
    include GoogleServiceAccount
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
