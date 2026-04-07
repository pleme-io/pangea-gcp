# frozen_string_literal: true

require 'spec_helper'

module BaseAttributesTestFixtures
  class BaseAttributesTestFixtures::TestBaseAttrs < Pangea::Resources::BaseAttributes
    attribute :name, Pangea::Resources::Types::Coercible::String
    attribute? :cidr, Pangea::Resources::Types::Coercible::String.optional
    attribute? :count, Pangea::Resources::Types::Coercible::Integer.optional
  end
end

RSpec.describe Pangea::Resources::BaseAttributes do

  describe '.terraform_reference?' do
    it 'returns true for terraform interpolation strings' do
      expect(described_class.terraform_reference?('${google_compute_network.vpc.id}')).to be true
    end

    it 'returns true for complex nested references' do
      expect(described_class.terraform_reference?('${module.vpc.outputs.id}')).to be true
    end

    it 'returns false for plain strings' do
      expect(described_class.terraform_reference?('hello-world')).to be false
    end

    it 'returns false for non-string values' do
      expect(described_class.terraform_reference?(42)).to be false
      expect(described_class.terraform_reference?(nil)).to be false
      expect(described_class.terraform_reference?(true)).to be false
    end

    it 'returns false for empty string' do
      expect(described_class.terraform_reference?('')).to be false
    end
  end

  describe '#terraform_reference? (instance method)' do
    let(:attrs) { BaseAttributesTestFixtures::TestBaseAttrs.new(name: 'test') }

    it 'delegates to class method' do
      expect(attrs.terraform_reference?('${ref}')).to be true
      expect(attrs.terraform_reference?('plain')).to be false
    end
  end

  describe 'transform_keys' do
    it 'normalizes string keys to symbols' do
      attrs = BaseAttributesTestFixtures::TestBaseAttrs.new('name' => 'hello', 'cidr' => '10.0.0.0/16')
      expect(attrs.name).to eq('hello')
      expect(attrs.cidr).to eq('10.0.0.0/16')
    end
  end

  describe '#copy_with' do
    it 'creates a new instance with merged attributes' do
      original = BaseAttributesTestFixtures::TestBaseAttrs.new(name: 'orig', cidr: '10.0.0.0/16')
      copy = original.copy_with(cidr: '172.16.0.0/12')

      expect(copy.name).to eq('orig')
      expect(copy.cidr).to eq('172.16.0.0/12')
      expect(original.cidr).to eq('10.0.0.0/16')
    end

    it 'accepts string keys in changes' do
      original = BaseAttributesTestFixtures::TestBaseAttrs.new(name: 'orig')
      copy = original.copy_with('name' => 'changed')
      expect(copy.name).to eq('changed')
    end
  end

  describe '#terraform_ref_or' do
    it 'yields the value when not a terraform reference' do
      attrs = BaseAttributesTestFixtures::TestBaseAttrs.new(name: 'hello')
      result = attrs.terraform_ref_or(:name) { |v| v.upcase }
      expect(result).to eq('HELLO')
    end

    it 'returns the raw reference when value is a terraform reference' do
      attrs = BaseAttributesTestFixtures::TestBaseAttrs.new(name: '${var.name}')
      result = attrs.terraform_ref_or(:name) { |v| v.upcase }
      expect(result).to eq('${var.name}')
    end
  end

  describe 'required vs optional attributes' do
    it 'raises on missing required attribute' do
      expect { BaseAttributesTestFixtures::TestBaseAttrs.new({}) }.to raise_error(Dry::Struct::Error)
    end

    it 'defaults optional attributes to nil' do
      attrs = BaseAttributesTestFixtures::TestBaseAttrs.new(name: 'test')
      expect(attrs.cidr).to be_nil
      expect(attrs.count).to be_nil
    end
  end
end
