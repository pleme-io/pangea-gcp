# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ContainerNodePoolAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :location, Dry::Types['strict.string']
          attribute :cluster, Dry::Types['strict.string']
          attribute :node_count, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :node_config, Dry::Types['nominal.any'].optional.default(nil)
          attribute :autoscaling, Dry::Types['nominal.any'].optional.default(nil)
          attribute :management, Dry::Types['nominal.any'].optional.default(nil)
          attribute :max_pods_per_node, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :node_locations, Dry::Types['nominal.any'].optional.default(nil)
          attribute :upgrade_settings, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
