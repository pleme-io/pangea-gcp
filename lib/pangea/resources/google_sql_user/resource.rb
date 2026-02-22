# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_sql_user/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleSqlUser
    def google_sql_user(name, attributes = {})
      attrs = Google::Types::SqlUserAttributes.new(attributes)
      resource(:google_sql_user, name) do
        name attrs.name
        project attrs.project if attrs.project
        instance attrs.instance
        password attrs.password if attrs.password
        host attrs.host if attrs.host
        type attrs.type if attrs.type
        deletion_policy attrs.deletion_policy if attrs.deletion_policy
      end
      ResourceReference.new(
        type: 'google_sql_user',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_sql_user.#{name}.id}" }
      )
    end
  end
  module Google
    include GoogleSqlUser
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
