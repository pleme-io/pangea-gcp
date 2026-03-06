# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_sql_database/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSqlDatabase
    include Pangea::Resources::ResourceBuilder

    define_resource :google_sql_database,
      attributes_class: Google::Types::SqlDatabaseAttributes,
      outputs: { id: :id, self_link: :self_link },
      map: [:name, :instance],
      map_present: [:project, :charset, :collation]
  end
  module Google
    include GoogleSqlDatabase
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
