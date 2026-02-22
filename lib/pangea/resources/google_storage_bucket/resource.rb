# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_storage_bucket/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleStorageBucket
    def google_storage_bucket(name, attributes = {})
      attrs = Google::Types::StorageBucketAttributes.new(attributes)
      resource(:google_storage_bucket, name) do
        name attrs.name
        project attrs.project if attrs.project
        location attrs.location
        storage_class attrs.storage_class if attrs.storage_class
        force_destroy attrs.force_destroy if !attrs.force_destroy.nil?
        uniform_bucket_level_access attrs.uniform_bucket_level_access if !attrs.uniform_bucket_level_access.nil?
        versioning attrs.versioning if attrs.versioning
        lifecycle_rule attrs.lifecycle_rule if attrs.lifecycle_rule
        cors attrs.cors if attrs.cors
        logging attrs.logging if attrs.logging
        encryption attrs.encryption if attrs.encryption
        labels attrs.labels if attrs.labels.any?
      end
      ResourceReference.new(
        type: 'google_storage_bucket',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_storage_bucket.#{name}.id}", self_link: "${google_storage_bucket.#{name}.self_link}", url: "${google_storage_bucket.#{name}.url}" }
      )
    end
  end
  module Google
    include GoogleStorageBucket
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
