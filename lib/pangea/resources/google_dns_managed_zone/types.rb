# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class DnsManagedZoneAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :dns_name, Dry::Types['strict.string']
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :visibility, Dry::Types['strict.string'].enum('public', 'private').optional.default(nil)
          attribute :dnssec_config, Dry::Types['nominal.any'].optional.default(nil)
          attribute :private_visibility_config, Dry::Types['nominal.any'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :force_destroy, Dry::Types['strict.bool'].optional.default(nil)
        end
      end
    end
  end
end
