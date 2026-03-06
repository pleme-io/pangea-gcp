# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ComputeAddressAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :region, Dry::Types['strict.string'].optional.default(nil)
          attribute :address_type, Dry::Types['strict.string'].enum('INTERNAL', 'EXTERNAL').optional.default(nil)
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :address, Dry::Types['strict.string'].optional.default(nil)
          attribute :subnetwork, Dry::Types['strict.string'].optional.default(nil)
          attribute :network_tier, Dry::Types['strict.string'].enum('PREMIUM', 'STANDARD').optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
        end
      end
    end
  end
end
