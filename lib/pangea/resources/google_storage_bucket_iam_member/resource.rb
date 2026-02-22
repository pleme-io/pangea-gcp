# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_storage_bucket_iam_member/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleStorageBucketIamMember
    def google_storage_bucket_iam_member(name, attributes = {})
      attrs = Google::Types::StorageBucketIamMemberAttributes.new(attributes)
      resource(:google_storage_bucket_iam_member, name) do
        bucket attrs.bucket
        role attrs.role
        member attrs.member
        condition attrs.condition if attrs.condition
      end
      ResourceReference.new(
        type: 'google_storage_bucket_iam_member',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_storage_bucket_iam_member.#{name}.id}" }
      )
    end
  end
  module Google
    include GoogleStorageBucketIamMember
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
