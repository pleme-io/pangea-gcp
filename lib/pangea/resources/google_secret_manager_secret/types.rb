# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class SecretManagerSecretAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :secret_id, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :replication, Dry::Types['nominal.any']
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :expire_time, Dry::Types['strict.string'].optional.default(nil)
          attribute :ttl, Dry::Types['strict.string'].optional.default(nil)
          attribute :rotation, Dry::Types['nominal.any'].optional.default(nil)
          attribute :topics, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
