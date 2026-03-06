# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_storage_bucket/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleStorageBucket
    include Pangea::Resources::ResourceBuilder

    define_resource :google_storage_bucket,
      attributes_class: Google::Types::StorageBucketAttributes,
      outputs: { id: :id, self_link: :self_link, url: :url },
      map: [:name, :location],
      map_present: [:project, :storage_class, :versioning, :lifecycle_rule, :cors, :logging, :encryption],
      map_bool: [:force_destroy, :uniform_bucket_level_access],
      labels: :labels
  end
  module Google
    include GoogleStorageBucket
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
