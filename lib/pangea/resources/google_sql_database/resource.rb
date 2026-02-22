# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_sql_database/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSqlDatabase
    def google_sql_database(name, attributes = {})
      attrs = Google::Types::SqlDatabaseAttributes.new(attributes)
      resource(:google_sql_database, name) do
        name attrs.name
        project attrs.project if attrs.project
        instance attrs.instance
        charset attrs.charset if attrs.charset
        collation attrs.collation if attrs.collation
      end
      ResourceReference.new(
        type: 'google_sql_database',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_sql_database.#{name}.id}", self_link: "${google_sql_database.#{name}.self_link}" }
      )
    end
  end
  module Google
    include GoogleSqlDatabase
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
