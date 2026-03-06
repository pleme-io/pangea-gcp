# frozen_string_literal: true
require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/google_redis_instance/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module GoogleRedisInstance
    include Pangea::Resources::ResourceBuilder

    define_resource :google_redis_instance,
      attributes_class: Google::Types::RedisInstanceAttributes,
      outputs: { id: :id, host: :host, port: :port, current_location_id: :current_location_id },
      map: [:name, :region, :memory_size_gb],
      map_present: [:project, :tier, :display_name, :redis_version, :redis_configs, :authorized_network, :connect_mode, :transit_encryption_mode, :replica_count, :read_replicas_mode],
      map_bool: [:auth_enabled],
      labels: :labels
  end
  module Google
    include GoogleRedisInstance
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Google)
