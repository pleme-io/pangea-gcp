# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_service_account/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleServiceAccount
    def google_service_account(name, attributes = {})
      attrs = Google::Types::ServiceAccountAttributes.new(attributes)
      resource(:google_service_account, name) do
        account_id attrs.account_id
        project attrs.project if attrs.project
        display_name attrs.display_name if attrs.display_name
        description attrs.description if attrs.description
        disabled attrs.disabled if !attrs.disabled.nil?
      end
      ResourceReference.new(
        type: 'google_service_account',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_service_account.#{name}.id}", email: "${google_service_account.#{name}.email}", unique_id: "${google_service_account.#{name}.unique_id}" }
      )
    end
  end
  module Google
    include GoogleServiceAccount
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
