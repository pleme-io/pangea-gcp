# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_pubsub_subscription/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GooglePubsubSubscription
    include Pangea::Resources::ResourceBuilder

    define_resource :google_pubsub_subscription,
      attributes_class: Google::Types::PubsubSubscriptionAttributes,
      outputs: { id: :id },
      map: [:name, :topic],
      map_present: [:project, :ack_deadline_seconds, :message_retention_duration, :filter, :dead_letter_policy, :retry_policy, :push_config, :expiration_policy],
      map_bool: [:retain_acked_messages, :enable_message_ordering],
      labels: :labels
  end
  module Google
    include GooglePubsubSubscription
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
