# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_sql_user/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSqlUser
    include Pangea::Resources::ResourceBuilder

    define_resource :google_sql_user,
      attributes_class: Google::Types::SqlUserAttributes,
      outputs: { id: :id },
      map: [:name, :instance],
      map_present: [:project, :password, :host, :type, :deletion_policy]
  end
  module Google
    include GoogleSqlUser
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
