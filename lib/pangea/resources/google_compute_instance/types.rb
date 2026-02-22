# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ComputeInstanceAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :zone, Dry::Types['strict.string']
          attribute :machine_type, Dry::Types['strict.string']
          attribute :boot_disk, Dry::Types['nominal.any']
          attribute :network_interface, Dry::Types['nominal.any']
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :tags, Dry::Types['nominal.any'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :metadata, Dry::Types['nominal.hash'].optional.default(nil)
          attribute :metadata_startup_script, Dry::Types['strict.string'].optional.default(nil)
          attribute :service_account, Dry::Types['nominal.any'].optional.default(nil)
          attribute :allow_stopping_for_update, Dry::Types['strict.bool'].optional.default(nil)
          attribute :deletion_protection, Dry::Types['strict.bool'].optional.default(nil)
          attribute :scheduling, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
