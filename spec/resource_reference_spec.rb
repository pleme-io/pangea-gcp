# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pangea::Resources::ResourceReference do
  let(:basic_ref) do
    described_class.new(
      type: :google_compute_instance,
      name: 'main',
      resource_attributes: { machine_type: 'n1-standard-1', name: 'my-vm' },
      outputs: { id: '${google_compute_instance.main.id}', self_link: '${google_compute_instance.main.self_link}' }
    )
  end

  describe 'construction' do
    it 'accepts symbol type and coerces to string' do
      expect(basic_ref.type).to eq('google_compute_instance')
    end

    it 'accepts string type' do
      ref = described_class.new(
        type: 'google_storage_bucket',
        name: 'mybucket',
        resource_attributes: {},
        outputs: {}
      )
      expect(ref.type).to eq('google_storage_bucket')
    end

    it 'accepts attributes: as alias for resource_attributes:' do
      ref = described_class.new(
        type: 'test',
        name: 'n',
        attributes: { foo: 'bar' },
        outputs: {}
      )
      expect(ref.resource_attributes).to eq({ foo: 'bar' })
    end

    it 'defaults outputs to empty hash when omitted' do
      ref = described_class.new(
        type: 'test',
        name: 'n',
        resource_attributes: {}
      )
      expect(ref.outputs).to eq({})
    end

    it 'accepts Dry::Struct for resource_attributes via to_h coercion' do
      struct = Struct.new(:a, :b).new(1, 2)
      ref = described_class.new(
        type: 'test',
        name: 'n',
        resource_attributes: struct,
        outputs: {}
      )
      expect(ref.resource_attributes).to be_a(Hash)
    end
  end

  describe '#resource_type' do
    it 'returns the type as a symbol' do
      expect(basic_ref.resource_type).to eq(:google_compute_instance)
    end
  end

  describe '#ref' do
    it 'generates terraform interpolation for any attribute' do
      expect(basic_ref.ref(:zone)).to eq('${google_compute_instance.main.zone}')
    end

    it 'works with string attribute names' do
      expect(basic_ref.ref('project')).to eq('${google_compute_instance.main.project}')
    end
  end

  describe '#[]' do
    it 'is an alias for #ref' do
      expect(basic_ref[:zone]).to eq(basic_ref.ref(:zone))
    end
  end

  describe '#id' do
    it 'returns terraform id interpolation' do
      expect(basic_ref.id).to eq('${google_compute_instance.main.id}')
    end
  end

  describe '#method_missing for outputs' do
    it 'delegates to outputs when key exists' do
      expect(basic_ref.self_link).to eq('${google_compute_instance.main.self_link}')
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true for output keys' do
      expect(basic_ref.respond_to?(:self_link)).to be true
    end

    it 'returns true for computed_attributes methods' do
      expect(basic_ref.respond_to?(:terraform_resource_name)).to be true
    end
  end

  describe '#computed_attributes' do
    it 'returns BaseComputedAttributes by default' do
      expect(basic_ref.computed_attributes).to be_a(Pangea::Resources::BaseComputedAttributes)
    end

    it 'provides terraform_resource_name' do
      expect(basic_ref.terraform_resource_name).to eq('google_compute_instance.main')
    end
  end

  describe '#to_h' do
    it 'returns a hash with type, name, attributes, and outputs' do
      h = basic_ref.to_h
      expect(h).to have_key(:type)
      expect(h).to have_key(:name)
      expect(h).to have_key(:attributes)
      expect(h).to have_key(:outputs)
    end
  end

  describe 'with computed_properties' do
    it 'delegates method_missing to computed_properties' do
      ref = described_class.new(
        type: 'test',
        name: 'n',
        resource_attributes: {},
        outputs: {},
        computed_properties: { custom_prop: 'custom_value' }
      )
      expect(ref.custom_prop).to eq('custom_value')
    end
  end
end
