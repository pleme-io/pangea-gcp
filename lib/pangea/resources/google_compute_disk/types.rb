# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ComputeDiskAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :zone, Dry::Types['strict.string']
          attribute :size, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :type, Dry::Types['strict.string'].optional.default(nil)
          attribute :image, Dry::Types['strict.string'].optional.default(nil)
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :snapshot, Dry::Types['strict.string'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :physical_block_size_bytes, Dry::Types['coercible.integer'].optional.default(nil)
        end
      end
    end
  end
end
