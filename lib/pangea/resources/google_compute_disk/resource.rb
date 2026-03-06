# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_compute_disk/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleComputeDisk
    include Pangea::Resources::ResourceBuilder

    define_resource :google_compute_disk,
      attributes_class: Google::Types::ComputeDiskAttributes,
      outputs: { id: :id, self_link: :self_link },
      map: [:name, :zone],
      map_present: [:project, :size, :type, :image, :description, :snapshot, :physical_block_size_bytes],
      labels: :labels
  end
  module Google
    include GoogleComputeDisk
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
