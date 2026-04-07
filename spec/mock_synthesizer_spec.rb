# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pangea::Testing::MockTerraformSynthesizer do
  subject(:synth) { described_class.new }

  describe '#synthesis' do
    it 'returns empty hash when no resources added' do
      expect(synth.synthesis).to eq({})
    end

    it 'returns resource key after adding a resource' do
      synth.google_compute_network('vpc', { name: 'test' })
      result = synth.synthesis
      expect(result).to have_key('resource')
      expect(result['resource']).to have_key('google_compute_network')
    end

    it 'does not include empty data or output sections' do
      synth.some_resource('name', {})
      result = synth.synthesis
      expect(result).not_to have_key('data')
      expect(result).not_to have_key('output')
    end
  end

  describe '#method_missing' do
    it 'accepts any method name as a resource type' do
      ref = synth.arbitrary_resource_type('myname', { key: 'val' })
      expect(ref).to be_a(Pangea::Testing::MockResourceReference)
    end

    it 'stores the resource config' do
      synth.my_resource('test', { foo: 'bar' })
      expect(synth.resources).to have_key('my_resource')
      expect(synth.resources['my_resource']['test']).to eq({ foo: 'bar' })
    end

    it 'handles nil config gracefully' do
      synth.my_resource('test')
      expect(synth.resources['my_resource']['test']).to eq({})
    end
  end

  describe '#respond_to_missing?' do
    it 'responds to any method' do
      expect(synth.respond_to?(:anything_at_all)).to be true
    end
  end

  describe 'multiple resource types' do
    it 'stores resources of different types independently' do
      synth.type_a('one', { a: 1 })
      synth.type_b('two', { b: 2 })

      expect(synth.resources.keys).to contain_exactly('type_a', 'type_b')
    end
  end
end

RSpec.describe Pangea::Testing::MockResourceReference do
  subject(:ref) { described_class.new('google_compute_instance', 'main', { zone: 'us-central1-a' }) }

  describe '#id' do
    it 'returns Terraform interpolation string' do
      expect(ref.id).to eq('${google_compute_instance.main.id}')
    end
  end

  describe '#arn' do
    it 'returns Terraform interpolation string for arn' do
      expect(ref.arn).to eq('${google_compute_instance.main.arn}')
    end
  end

  describe '#to_h' do
    it 'returns hash with type, name, and attributes' do
      h = ref.to_h
      expect(h[:type]).to eq('google_compute_instance')
      expect(h[:name]).to eq('main')
      expect(h[:attributes]).to eq({ zone: 'us-central1-a' })
    end
  end

  describe '#method_missing' do
    it 'returns attribute value when key exists as symbol' do
      expect(ref.zone).to eq('us-central1-a')
    end

    it 'returns attribute value when key exists as string' do
      ref2 = described_class.new('t', 'n', { 'string_key' => 'value' })
      expect(ref2.string_key).to eq('value')
    end

    it 'returns interpolation string for unknown attributes' do
      expect(ref.self_link).to eq('${google_compute_instance.main.self_link}')
    end
  end

  describe '#respond_to_missing?' do
    it 'responds to any method' do
      expect(ref.respond_to?(:nonexistent)).to be true
    end
  end

  describe 'empty attributes' do
    subject(:empty_ref) { described_class.new('type', 'name') }

    it 'defaults attributes to empty hash' do
      expect(empty_ref.attributes).to eq({})
    end

    it 'returns interpolation for any attribute access' do
      expect(empty_ref.some_field).to eq('${type.name.some_field}')
    end
  end
end
