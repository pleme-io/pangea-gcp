# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class SecretManagerSecretVersionAttributes < Pangea::Resources::BaseAttributes
          attribute :secret, Dry::Types['strict.string']
          attribute :secret_data, Dry::Types['strict.string']
          attribute :enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :deletion_policy, Dry::Types['strict.string'].optional.default(nil)
        end
      end
    end
  end
end
