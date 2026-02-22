# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class StorageBucketIamMemberAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :bucket, Dry::Types['strict.string']
          attribute :role, Dry::Types['strict.string']
          attribute :member, Dry::Types['strict.string']
          attribute :condition, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
