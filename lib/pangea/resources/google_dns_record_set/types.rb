# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class DnsRecordSetAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :managed_zone, Dry::Types['strict.string']
          attribute :type, Dry::Types['strict.string']
          attribute :ttl, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :rrdatas, Dry::Types['nominal.any'].optional.default(nil)
          attribute :routing_policy, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
