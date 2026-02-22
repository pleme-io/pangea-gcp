# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_pubsub_subscription/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GooglePubsubSubscription
    def google_pubsub_subscription(name, attributes = {})
      attrs = Google::Types::PubsubSubscriptionAttributes.new(attributes)
      resource(:google_pubsub_subscription, name) do
        name attrs.name
        project attrs.project if attrs.project
        topic attrs.topic
        ack_deadline_seconds attrs.ack_deadline_seconds if attrs.ack_deadline_seconds
        labels attrs.labels if attrs.labels.any?
        message_retention_duration attrs.message_retention_duration if attrs.message_retention_duration
        retain_acked_messages attrs.retain_acked_messages if !attrs.retain_acked_messages.nil?
        filter attrs.filter if attrs.filter
        dead_letter_policy attrs.dead_letter_policy if attrs.dead_letter_policy
        retry_policy attrs.retry_policy if attrs.retry_policy
        push_config attrs.push_config if attrs.push_config
        expiration_policy attrs.expiration_policy if attrs.expiration_policy
        enable_message_ordering attrs.enable_message_ordering if !attrs.enable_message_ordering.nil?
      end
      ResourceReference.new(
        type: 'google_pubsub_subscription',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_pubsub_subscription.#{name}.id}" }
      )
    end
  end
  module Google
    include GooglePubsubSubscription
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
