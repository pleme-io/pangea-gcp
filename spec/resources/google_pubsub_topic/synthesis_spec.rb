# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_pubsub_topic/resource'

RSpec.describe 'google_pubsub_topic synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_pubsub_topic,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-topic' },
    expected_outputs: [:id]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_pubsub_topic(:test, { name: "my-topic" })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_pubsub_topic][:test]).to be_a(Hash)
  end

  it 'synthesizes with all optional attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_pubsub_topic(:full, {
        name: "events-topic",
        project: "my-project",
        labels: { "env" => "prod" },
        kms_key_name: "projects/p/locations/l/keyRings/kr/cryptoKeys/ck",
        message_retention_duration: "604800s",
        message_storage_policy: { allowed_persistence_regions: ["us-central1"] },
        schema_settings: { schema: "projects/p/schemas/my-schema", encoding: "JSON" }
      })
    end
    result = synthesizer.synthesis
    topic = result[:resource][:google_pubsub_topic][:full]
    expect(topic[:kms_key_name]).to be_a(String)
    expect(topic[:message_retention_duration]).to eq("604800s")
    expect(topic[:schema_settings]).to be_a(Hash)
  end

  it 'returns a ResourceReference with correct outputs' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_pubsub_topic(:ref_test, { name: "ref-topic" })
    end
    expect(ref.type).to eq('google_pubsub_topic')
    expect(ref.outputs[:id]).to eq("${google_pubsub_topic.ref_test.id}")
  end
end
