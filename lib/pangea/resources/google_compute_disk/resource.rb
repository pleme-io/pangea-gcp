# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_disk/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeDisk
    def google_compute_disk(name, attributes = {})
      attrs = Google::Types::ComputeDiskAttributes.new(attributes)
      resource(:google_compute_disk, name) do
        name attrs.name
        project attrs.project if attrs.project
        zone attrs.zone
        size attrs.size if attrs.size
        type attrs.type if attrs.type
        image attrs.image if attrs.image
        description attrs.description if attrs.description
        snapshot attrs.snapshot if attrs.snapshot
        labels attrs.labels if attrs.labels.any?
        physical_block_size_bytes attrs.physical_block_size_bytes if attrs.physical_block_size_bytes
      end
      ResourceReference.new(
        type: 'google_compute_disk',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_compute_disk.#{name}.id}", self_link: "${google_compute_disk.#{name}.self_link}" }
      )
    end
  end
  module Google
    include GoogleComputeDisk
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
