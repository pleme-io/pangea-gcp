# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ProjectAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project_id, Dry::Types['strict.string']
          attribute :org_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :billing_account, Dry::Types['strict.string'].optional.default(nil)
          attribute :folder_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :auto_create_network, Dry::Types['strict.bool'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
        end
      end
    end
  end
end
