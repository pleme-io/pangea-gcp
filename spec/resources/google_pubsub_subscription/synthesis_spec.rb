# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_pubsub_subscription/resource'

RSpec.describe 'google_pubsub_subscription synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_pubsub_subscription,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-sub', topic: 'test-topic' },
    expected_outputs: [:id]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_pubsub_subscription(:test, { name: "my-subscription", topic: "my-topic", ack_deadline_seconds: 20 })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_pubsub_subscription][:test]).to be_a(Hash)
  end

  it 'synthesizes with dead letter policy and retry' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_pubsub_subscription(:full, {
        name: "full-subscription",
        project: "my-project",
        topic: "events-topic",
        ack_deadline_seconds: 30,
        labels: { "team" => "backend" },
        message_retention_duration: "604800s",
        retain_acked_messages: true,
        filter: "attributes.type = \"important\"",
        dead_letter_policy: {
          dead_letter_topic: "projects/my-project/topics/dead-letters",
          max_delivery_attempts: 5
        },
        retry_policy: {
          minimum_backoff: "10s",
          maximum_backoff: "600s"
        },
        enable_message_ordering: true,
        expiration_policy: { ttl: "2592000s" }
      })
    end
    result = synthesizer.synthesis
    sub = result[:resource][:google_pubsub_subscription][:full]
    expect(sub[:retain_acked_messages]).to eq(true)
    expect(sub[:enable_message_ordering]).to eq(true)
    expect(sub[:dead_letter_policy]).to be_a(Hash)
    expect(sub[:retry_policy]).to be_a(Hash)
    expect(sub[:expiration_policy]).to be_a(Hash)
  end

  it 'synthesizes with push config' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_pubsub_subscription(:push, {
        name: "push-subscription",
        topic: "my-topic",
        push_config: {
          push_endpoint: "https://example.com/push",
          attributes: { "x-goog-version" => "v1" }
        }
      })
    end
    result = synthesizer.synthesis
    sub = result[:resource][:google_pubsub_subscription][:push]
    expect(sub[:push_config]).to be_a(Hash)
    expect(sub[:push_config][:push_endpoint]).to eq("https://example.com/push")
  end
end
