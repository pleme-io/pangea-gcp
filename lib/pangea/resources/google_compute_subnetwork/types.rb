# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ComputeSubnetworkAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :region, Dry::Types['strict.string']
          attribute :network, Dry::Types['strict.string']
          attribute :ip_cidr_range, Dry::Types['strict.string']
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :private_ip_google_access, Dry::Types['strict.bool'].optional.default(nil)
          attribute :secondary_ip_range, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
