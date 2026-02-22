# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class SqlDatabaseAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :instance, Dry::Types['strict.string']
          attribute :charset, Dry::Types['strict.string'].optional.default(nil)
          attribute :collation, Dry::Types['strict.string'].optional.default(nil)
        end
      end
    end
  end
end
