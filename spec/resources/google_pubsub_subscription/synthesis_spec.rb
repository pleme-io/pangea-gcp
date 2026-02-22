# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_pubsub_subscription/resource'

RSpec.describe 'google_pubsub_subscription synthesis' do
  include Pangea::Resources::Google
  it 'synthesizes' do
    result = TerraformSynthesizer.new.tap { |s|
      s.instance_eval do
        extend Pangea::Resources::Google
        google_pubsub_subscription(:test, { name: "my-subscription", topic: "my-topic", ack_deadline_seconds: 20 })
      end
    }.synthesis
    expect(result[:resource][:google_pubsub_subscription][:test]).to be_a(Hash)
  end
end
