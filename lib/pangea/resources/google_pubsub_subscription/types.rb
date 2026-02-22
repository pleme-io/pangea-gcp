# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class PubsubSubscriptionAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :topic, Dry::Types['strict.string']
          attribute :ack_deadline_seconds, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :message_retention_duration, Dry::Types['strict.string'].optional.default(nil)
          attribute :retain_acked_messages, Dry::Types['strict.bool'].optional.default(nil)
          attribute :filter, Dry::Types['strict.string'].optional.default(nil)
          attribute :dead_letter_policy, Dry::Types['nominal.any'].optional.default(nil)
          attribute :retry_policy, Dry::Types['nominal.any'].optional.default(nil)
          attribute :push_config, Dry::Types['nominal.any'].optional.default(nil)
          attribute :expiration_policy, Dry::Types['nominal.any'].optional.default(nil)
          attribute :enable_message_ordering, Dry::Types['strict.bool'].optional.default(nil)
        end
      end
    end
  end
end
