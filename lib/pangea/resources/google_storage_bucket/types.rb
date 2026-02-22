# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class StorageBucketAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :location, Dry::Types['strict.string']
          attribute :storage_class, Dry::Types['strict.string'].enum('STANDARD', 'NEARLINE', 'COLDLINE', 'ARCHIVE', 'MULTI_REGIONAL', 'REGIONAL').optional.default(nil)
          attribute :force_destroy, Dry::Types['strict.bool'].optional.default(nil)
          attribute :uniform_bucket_level_access, Dry::Types['strict.bool'].optional.default(nil)
          attribute :versioning, Dry::Types['nominal.any'].optional.default(nil)
          attribute :lifecycle_rule, Dry::Types['nominal.any'].optional.default(nil)
          attribute :cors, Dry::Types['nominal.any'].optional.default(nil)
          attribute :logging, Dry::Types['nominal.any'].optional.default(nil)
          attribute :encryption, Dry::Types['nominal.any'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
        end
      end
    end
  end
end
