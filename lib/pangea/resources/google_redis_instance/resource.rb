# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_redis_instance/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleRedisInstance
    def google_redis_instance(name, attributes = {})
      attrs = Google::Types::RedisInstanceAttributes.new(attributes)
      resource(:google_redis_instance, name) do
        name attrs.name
        project attrs.project if attrs.project
        region attrs.region
        tier attrs.tier if attrs.tier
        memory_size_gb attrs.memory_size_gb
        labels attrs.labels if attrs.labels.any?
        display_name attrs.display_name if attrs.display_name
        redis_version attrs.redis_version if attrs.redis_version
        redis_configs attrs.redis_configs if attrs.redis_configs
        authorized_network attrs.authorized_network if attrs.authorized_network
        connect_mode attrs.connect_mode if attrs.connect_mode
        auth_enabled attrs.auth_enabled if !attrs.auth_enabled.nil?
        transit_encryption_mode attrs.transit_encryption_mode if attrs.transit_encryption_mode
        replica_count attrs.replica_count if attrs.replica_count
        read_replicas_mode attrs.read_replicas_mode if attrs.read_replicas_mode
      end
      ResourceReference.new(
        type: 'google_redis_instance',
        name: name,
        resource_attributes: attrs.to_h,
        outputs: { id: "${google_redis_instance.#{name}.id}", host: "${google_redis_instance.#{name}.host}", port: "${google_redis_instance.#{name}.port}", current_location_id: "${google_redis_instance.#{name}.current_location_id}" }
      )
    end
  end
  module Google
    include GoogleRedisInstance
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
