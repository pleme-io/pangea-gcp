# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class PubsubTopicAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :kms_key_name, Dry::Types['strict.string'].optional.default(nil)
          attribute :message_retention_duration, Dry::Types['strict.string'].optional.default(nil)
          attribute :message_storage_policy, Dry::Types['nominal.any'].optional.default(nil)
          attribute :schema_settings, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
