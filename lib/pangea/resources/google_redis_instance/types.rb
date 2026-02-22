# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class RedisInstanceAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :region, Dry::Types['strict.string']
          attribute :tier, Dry::Types['strict.string'].enum('BASIC', 'STANDARD_HA').optional.default(nil)
          attribute :memory_size_gb, Dry::Types['coercible.integer']
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :display_name, Dry::Types['strict.string'].optional.default(nil)
          attribute :redis_version, Dry::Types['strict.string'].optional.default(nil)
          attribute :redis_configs, Dry::Types['nominal.hash'].optional.default(nil)
          attribute :authorized_network, Dry::Types['strict.string'].optional.default(nil)
          attribute :connect_mode, Dry::Types['strict.string'].enum('DIRECT_PEERING', 'PRIVATE_SERVICE_ACCESS').optional.default(nil)
          attribute :auth_enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :transit_encryption_mode, Dry::Types['strict.string'].enum('SERVER_AUTHENTICATION', 'DISABLED').optional.default(nil)
          attribute :replica_count, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :read_replicas_mode, Dry::Types['strict.string'].optional.default(nil)
        end
      end
    end
  end
end
