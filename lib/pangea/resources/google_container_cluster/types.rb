# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ContainerClusterAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :location, Dry::Types['strict.string']
          attribute :initial_node_count, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :remove_default_node_pool, Dry::Types['strict.bool'].optional.default(nil)
          attribute :network, Dry::Types['strict.string'].optional.default(nil)
          attribute :subnetwork, Dry::Types['strict.string'].optional.default(nil)
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :min_master_version, Dry::Types['strict.string'].optional.default(nil)
          attribute :deletion_protection, Dry::Types['strict.bool'].optional.default(nil)
          attribute :networking_mode, Dry::Types['strict.string'].enum('VPC_NATIVE', 'ROUTES').optional.default(nil)
          attribute :ip_allocation_policy, Dry::Types['nominal.any'].optional.default(nil)
          attribute :private_cluster_config, Dry::Types['nominal.any'].optional.default(nil)
          attribute :master_auth, Dry::Types['nominal.any'].optional.default(nil)
          attribute :workload_identity_config, Dry::Types['nominal.any'].optional.default(nil)
          attribute :release_channel, Dry::Types['nominal.any'].optional.default(nil)
          attribute :resource_labels, Dry::Types['nominal.hash'].default({}.freeze)
        end
      end
    end
  end
end
