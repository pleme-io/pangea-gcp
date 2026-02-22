# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_project_iam_member/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleProjectIamMember
    def google_project_iam_member(name, attributes = {})
      attrs = Google::Types::ProjectIamMemberAttributes.new(attributes)
      resource(:google_project_iam_member, name) do
        project attrs.project
        role attrs.role
        member attrs.member
        condition attrs.condition if attrs.condition
      end
      ResourceReference.new(
        type: 'google_project_iam_member',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_project_iam_member.#{name}.id}" }
      )
    end
  end
  module Google
    include GoogleProjectIamMember
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
