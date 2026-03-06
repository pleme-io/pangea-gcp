# frozen_string_literal: true
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class SqlUserAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :instance, Dry::Types['strict.string']
          attribute :password, Dry::Types['strict.string'].optional.default(nil)
          attribute :host, Dry::Types['strict.string'].optional.default(nil)
          attribute :type, Dry::Types['strict.string'].enum('BUILT_IN', 'CLOUD_IAM_USER', 'CLOUD_IAM_SERVICE_ACCOUNT').optional.default(nil)
          attribute :deletion_policy, Dry::Types['strict.string'].optional.default(nil)
        end
      end
    end
  end
end
