# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class SqlDatabaseAttributes < Pangea::Resources::BaseAttributes
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
