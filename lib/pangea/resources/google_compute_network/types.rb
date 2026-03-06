# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ComputeNetworkAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :auto_create_subnetworks, Dry::Types['strict.bool'].optional.default(nil)
          attribute :routing_mode, Dry::Types['strict.string'].enum('REGIONAL', 'GLOBAL').optional.default(nil)
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :mtu, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :delete_default_routes_on_create, Dry::Types['strict.bool'].optional.default(nil)
        end
      end
    end
  end
end
