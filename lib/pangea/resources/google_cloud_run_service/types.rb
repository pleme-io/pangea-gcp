# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class CloudRunServiceAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :location, Dry::Types['strict.string']
          attribute :template, Dry::Types['nominal.any']
          attribute :traffic, Dry::Types['nominal.any'].optional.default(nil)
          attribute :metadata, Dry::Types['nominal.any'].optional.default(nil)
          attribute :autogenerate_revision_name, Dry::Types['strict.bool'].optional.default(nil)
        end
      end
    end
  end
end
