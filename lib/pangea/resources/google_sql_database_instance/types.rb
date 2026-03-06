# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class SqlDatabaseInstanceAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :region, Dry::Types['strict.string']
          attribute :database_version, Dry::Types['strict.string']
          attribute :settings, Dry::Types['nominal.any']
          attribute :deletion_protection, Dry::Types['strict.bool'].optional.default(nil)
          attribute :root_password, Dry::Types['strict.string'].optional.default(nil)
          attribute :master_instance_name, Dry::Types['strict.string'].optional.default(nil)
          attribute :replica_configuration, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
