# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class SecretManagerSecretVersionAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :secret, Dry::Types['strict.string']
          attribute :secret_data, Dry::Types['strict.string']
          attribute :enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :deletion_policy, Dry::Types['strict.string'].optional.default(nil)
        end
      end
    end
  end
end
