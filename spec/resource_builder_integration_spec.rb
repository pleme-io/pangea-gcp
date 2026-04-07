# frozen_string_literal: true

require 'spec_helper'

module ResourceBuilderTestFixtures
  class TestAttrs < Pangea::Resources::BaseAttributes
    attribute :name, Pangea::Resources::Types::Coercible::String
    attribute? :description, Pangea::Resources::Types::Coercible::String.optional
    attribute? :enabled, Pangea::Resources::Types::Bool.optional
    attribute? :count, Pangea::Resources::Types::Coercible::Integer.optional
    attribute? :labels, Pangea::Resources::Types::Hash.default({}.freeze)
    attribute? :tags, Pangea::Resources::Types::Hash.default({}.freeze)
  end
end

RSpec.describe 'ResourceBuilder integration' do
  include Pangea::Testing::SynthesisTestHelpers

  let(:resource_module) do
    Module.new do
      include Pangea::Resources::ResourceBuilder

      define_resource :test_resource,
        attributes_class: ResourceBuilderTestFixtures::TestAttrs,
        outputs: { id: :id, self_link: :self_link },
        map: [:name],
        map_present: [:description, :count],
        map_bool: [:enabled],
        labels: :labels,
        tags: :tags
    end
  end

  let(:synth) do
    s = create_synthesizer
    s.extend(resource_module)
    s
  end

  describe 'map_present behavior' do
    it 'omits nil optional attributes from synthesis output' do
      synth.test_resource('t', { name: 'hello' })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config).to have_key('name')
      expect(config).not_to have_key('description')
      expect(config).not_to have_key('count')
    end

    it 'includes non-nil optional attributes' do
      synth.test_resource('t', { name: 'hello', description: 'world', count: 42 })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config['description']).to eq('world')
      expect(config['count']).to eq(42)
    end
  end

  describe 'map_bool behavior' do
    it 'omits boolean attribute when nil' do
      synth.test_resource('t', { name: 'hello' })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config).not_to have_key('enabled')
    end

    it 'includes boolean false (not confused with nil)' do
      synth.test_resource('t', { name: 'hello', enabled: false })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config).to have_key('enabled')
      expect(config['enabled']).to eq(false)
    end

    it 'includes boolean true' do
      synth.test_resource('t', { name: 'hello', enabled: true })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config['enabled']).to eq(true)
    end
  end

  describe 'labels behavior' do
    it 'omits labels when empty hash' do
      synth.test_resource('t', { name: 'hello', labels: {} })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config).not_to have_key('labels')
    end

    it 'includes labels when non-empty' do
      synth.test_resource('t', { name: 'hello', labels: { env: 'prod' } })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config).to have_key('labels')
      expect(config['labels']).to include('env' => 'prod')
    end
  end

  describe 'tags behavior' do
    it 'omits tags when empty hash' do
      synth.test_resource('t', { name: 'hello', tags: {} })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config).not_to have_key('tags')
    end

    it 'includes tags when non-empty' do
      synth.test_resource('t', { name: 'hello', tags: { 'Name' => 'test' } })
      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'test_resource', 't')

      expect(config).to have_key('tags')
    end
  end

  describe 'ResourceReference returned' do
    it 'returns a ResourceReference with correct type' do
      ref = synth.test_resource('myname', { name: 'hello' })

      expect(ref).to be_a(Pangea::Resources::ResourceReference)
      expect(ref.resource_type).to eq(:test_resource)
    end

    it 'populates outputs with Terraform interpolation strings' do
      ref = synth.test_resource('myname', { name: 'hello' })

      expect(ref.id).to eq('${test_resource.myname.id}')
      expect(ref.self_link).to eq('${test_resource.myname.self_link}')
    end

    it 'stores resource_attributes from the validated struct' do
      ref = synth.test_resource('myname', { name: 'hello', description: 'desc' })

      expect(ref.resource_attributes).to include(name: 'hello', description: 'desc')
    end
  end

  describe 'multiple resources on one synthesizer' do
    it 'accumulates multiple resources of the same type' do
      synth.test_resource('first', { name: 'a' })
      synth.test_resource('second', { name: 'b' })
      result = normalize_synthesis(synth.synthesis)

      resources = result.dig('resource', 'test_resource')
      expect(resources.keys).to contain_exactly('first', 'second')
      expect(resources['first']['name']).to eq('a')
      expect(resources['second']['name']).to eq('b')
    end
  end

  describe 'resource_definitions introspection' do
    it 'exposes registered resource definitions' do
      defs = resource_module.resource_definitions
      expect(defs).to have_key(:test_resource)
      expect(defs[:test_resource][:attributes_class]).to eq(ResourceBuilderTestFixtures::TestAttrs)
    end
  end

  describe 'custom block execution' do
    let(:custom_module) do
      Module.new do
        include Pangea::Resources::ResourceBuilder

        define_resource :test_custom,
          attributes_class: ResourceBuilderTestFixtures::TestAttrs,
          outputs: { id: :id },
          map: [:name] do |dsl, attrs|
            dsl.description("custom-#{attrs.name}") if attrs.description.nil?
          end
      end
    end

    it 'executes the custom block during synthesis' do
      s = create_synthesizer
      s.extend(custom_module)
      s.test_custom('t', { name: 'hello' })
      result = normalize_synthesis(s.synthesis)
      config = result.dig('resource', 'test_custom', 't')

      expect(config['description']).to eq('custom-hello')
    end
  end

  describe 'attribute validation via Dry::Struct' do
    it 'raises on missing required attributes' do
      expect {
        synth.test_resource('t', {})
      }.to raise_error(Dry::Struct::Error)
    end

    it 'coerces string keys to symbols via BaseAttributes transform_keys' do
      ref = synth.test_resource('t', { 'name' => 'hello' })
      expect(ref.resource_attributes[:name]).to eq('hello')
    end
  end
end
