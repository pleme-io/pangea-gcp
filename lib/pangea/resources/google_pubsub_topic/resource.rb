# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_pubsub_topic/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GooglePubsubTopic
    include Pangea::Resources::ResourceBuilder

    define_resource :google_pubsub_topic,
      attributes_class: Google::Types::PubsubTopicAttributes,
      outputs: { id: :id },
      map: [:name],
      map_present: [:project, :kms_key_name, :message_retention_duration, :message_storage_policy, :schema_settings],
      labels: :labels
  end
  module Google
    include GooglePubsubTopic
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
