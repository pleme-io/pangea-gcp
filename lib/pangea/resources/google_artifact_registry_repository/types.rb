# frozen_string_literal: true
require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Google
      module Types
        class ArtifactRegistryRepositoryAttributes < Dry::Struct
          transform_keys(&:to_sym)
          attribute :repository_id, Dry::Types['strict.string']
          attribute :project, Dry::Types['strict.string'].optional.default(nil)
          attribute :location, Dry::Types['strict.string']
          attribute :format, Dry::Types['strict.string'].enum('DOCKER', 'MAVEN', 'NPM', 'PYTHON', 'APT', 'YUM', 'GO', 'KFP')
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
          attribute :labels, Dry::Types['nominal.hash'].default({}.freeze)
          attribute :kms_key_name, Dry::Types['strict.string'].optional.default(nil)
          attribute :mode, Dry::Types['strict.string'].enum('STANDARD_REPOSITORY', 'VIRTUAL_REPOSITORY', 'REMOTE_REPOSITORY').optional.default(nil)
          attribute :cleanup_policy_dry_run, Dry::Types['strict.bool'].optional.default(nil)
          attribute :cleanup_policies, Dry::Types['nominal.any'].optional.default(nil)
          attribute :docker_config, Dry::Types['nominal.any'].optional.default(nil)
          attribute :maven_config, Dry::Types['nominal.any'].optional.default(nil)
        end
      end
    end
  end
end
