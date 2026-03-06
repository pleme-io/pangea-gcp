# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_sql_database_instance/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSqlDatabaseInstance
    include Pangea::Resources::ResourceBuilder

    define_resource :google_sql_database_instance,
      attributes_class: Google::Types::SqlDatabaseInstanceAttributes,
      outputs: { id: :id, connection_name: :connection_name, self_link: :self_link, ip_address: :ip_address },
      map: [:name, :region, :database_version, :settings],
      map_present: [:project, :root_password, :master_instance_name, :replica_configuration],
      map_bool: [:deletion_protection]
  end
  module Google
    include GoogleSqlDatabaseInstance
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
