# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ServiceAccountAttributes < Pangea::Resources::BaseAttributes
          attribute :account_id, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :display_name, Dry::Types['strict.string'].optional.default(nil)
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :disabled, Dry::Types['strict.bool'].optional.default(nil)
        end
      end
    end
  end
end
