# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ComputeFirewallAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :network, Dry::Types['strict.string']
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :direction, Dry::Types['strict.string'].enum('INGRESS', 'EGRESS').optional.default(nil)
          attribute :priority, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :allow, Dry::Types['nominal.any'].optional.default(nil)
          attribute :deny, Dry::Types['nominal.any'].optional.default(nil)
          attribute :source_ranges, Dry::Types['nominal.any'].optional.default(nil)
          attribute :destination_ranges, Dry::Types['nominal.any'].optional.default(nil)
          attribute :source_tags, Dry::Types['nominal.any'].optional.default(nil)
          attribute :target_tags, Dry::Types['nominal.any'].optional.default(nil)
          attribute :source_service_accounts, Dry::Types['nominal.any'].optional.default(nil)
          attribute :target_service_accounts, Dry::Types['nominal.any'].optional.default(nil)
          attribute :disabled, Dry::Types['strict.bool'].optional.default(nil)
        end
      end
    end
  end
end
