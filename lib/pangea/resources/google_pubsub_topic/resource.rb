# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_pubsub_topic/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GooglePubsubTopic
    def google_pubsub_topic(name, attributes = {})
      attrs = Google::Types::PubsubTopicAttributes.new(attributes)
      resource(:google_pubsub_topic, name) do
        name attrs.name
        project attrs.project if attrs.project
        labels attrs.labels if attrs.labels.any?
        kms_key_name attrs.kms_key_name if attrs.kms_key_name
        message_retention_duration attrs.message_retention_duration if attrs.message_retention_duration
        message_storage_policy attrs.message_storage_policy if attrs.message_storage_policy
        schema_settings attrs.schema_settings if attrs.schema_settings
      end
      ResourceReference.new(
        type: 'google_pubsub_topic',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_pubsub_topic.#{name}.id}" }
      )
    end
  end
  module Google
    include GooglePubsubTopic
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
