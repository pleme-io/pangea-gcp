# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_redis_instance/resource'

RSpec.describe 'google_redis_instance synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_redis_instance,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-redis', region: 'us-central1', memory_size_gb: 1 },
    expected_outputs: [:id, :host, :port, :current_location_id]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_redis_instance(:test, { name: "my-redis", region: "us-central1", memory_size_gb: 1, tier: "BASIC" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_redis_instance][:test]).to be_a(Hash)
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_redis_instance(:full, {
        name: "prod-redis",
        project: "my-project",
        region: "us-central1",
        tier: "STANDARD_HA",
        memory_size_gb: 16,
        labels: { "env" => "production" },
        display_name: "Production Redis",
        redis_version: "REDIS_7_0",
        redis_configs: { "maxmemory-policy" => "allkeys-lru" },
        authorized_network: "projects/my-project/global/networks/my-vpc",
        connect_mode: "PRIVATE_SERVICE_ACCESS",
        auth_enabled: true,
        transit_encryption_mode: "SERVER_AUTHENTICATION",
        replica_count: 2,
        read_replicas_mode: "READ_REPLICAS_ENABLED"
      })
    end
    result = synthesizer.synthesis
    redis = result[:resource][:google_redis_instance][:full]
    expect(redis[:tier]).to eq("STANDARD_HA")
    expect(redis[:memory_size_gb]).to eq(16)
    expect(redis[:auth_enabled]).to eq(true)
    expect(redis[:transit_encryption_mode]).to eq("SERVER_AUTHENTICATION")
    expect(redis[:replica_count]).to eq(2)
  end

  it 'rejects invalid tier enum value' do
    expect {
      Google::Types::RedisInstanceAttributes.new(
        name: "test", region: "us-central1", memory_size_gb: 1, tier: "PREMIUM"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'rejects invalid connect_mode enum value' do
    expect {
      Google::Types::RedisInstanceAttributes.new(
        name: "test", region: "us-central1", memory_size_gb: 1, connect_mode: "PUBLIC"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'rejects invalid transit_encryption_mode enum value' do
    expect {
      Google::Types::RedisInstanceAttributes.new(
        name: "test", region: "us-central1", memory_size_gb: 1, transit_encryption_mode: "ENABLED"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with host and port outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_redis_instance(:ref_test, { name: "ref-redis", region: "us-central1", memory_size_gb: 1 })
    end
    expect(ref.type).to eq('google_redis_instance')
    expect(ref.outputs[:host]).to eq("${google_redis_instance.ref_test.host}")
    expect(ref.outputs[:port]).to eq("${google_redis_instance.ref_test.port}")
    expect(ref.outputs[:current_location_id]).to eq("${google_redis_instance.ref_test.current_location_id}")
  end
end
