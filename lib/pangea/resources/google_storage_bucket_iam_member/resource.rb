# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_storage_bucket_iam_member/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleStorageBucketIamMember
    include Pangea::Resources::ResourceBuilder

    define_resource :google_storage_bucket_iam_member,
      attributes_class: Google::Types::StorageBucketIamMemberAttributes,
      outputs: { id: :id },
      map: [:bucket, :role, :member],
      map_present: [:condition]
  end
  module Google
    include GoogleStorageBucketIamMember
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
