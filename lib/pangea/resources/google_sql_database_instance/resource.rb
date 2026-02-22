# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_sql_database_instance/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSqlDatabaseInstance
    def google_sql_database_instance(name, attributes = {})
      attrs = Google::Types::SqlDatabaseInstanceAttributes.new(attributes)
      resource(:google_sql_database_instance, name) do
        name attrs.name
        project attrs.project if attrs.project
        region attrs.region
        database_version attrs.database_version
        settings attrs.settings
        deletion_protection attrs.deletion_protection if !attrs.deletion_protection.nil?
        root_password attrs.root_password if attrs.root_password
        master_instance_name attrs.master_instance_name if attrs.master_instance_name
        replica_configuration attrs.replica_configuration if attrs.replica_configuration
      end
      ResourceReference.new(
        type: 'google_sql_database_instance',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_sql_database_instance.#{name}.id}", connection_name: "${google_sql_database_instance.#{name}.connection_name}", self_link: "${google_sql_database_instance.#{name}.self_link}", ip_address: "${google_sql_database_instance.#{name}.ip_address}" }
      )
    end
  end
  module Google
    include GoogleSqlDatabaseInstance
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
