# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pangea::Testing::IndifferentHash do
  describe '.deep_convert' do
    it 'converts a simple hash' do
      result = described_class.deep_convert({ foo: 'bar' })
      expect(result).to be_a(described_class)
      expect(result['foo']).to eq('bar')
    end

    it 'converts nested hashes recursively' do
      input = { outer: { inner: 'value' } }
      result = described_class.deep_convert(input)
      expect(result['outer']).to be_a(described_class)
      expect(result['outer']['inner']).to eq('value')
    end

    it 'converts hashes inside arrays' do
      input = { items: [{ name: 'a' }, { name: 'b' }] }
      result = described_class.deep_convert(input)
      expect(result['items']).to be_an(Array)
      expect(result['items'][0]).to be_a(described_class)
      expect(result['items'][0]['name']).to eq('a')
    end

    it 'preserves non-hash non-array values' do
      expect(described_class.deep_convert('string')).to eq('string')
      expect(described_class.deep_convert(42)).to eq(42)
      expect(described_class.deep_convert(nil)).to be_nil
    end
  end

  describe '#[]' do
    subject(:hash) do
      h = described_class.new
      h['string_key'] = 'from_string'
      h[:symbol_key] = 'from_symbol'
      h
    end

    it 'accesses string-stored values with symbol key' do
      expect(hash[:string_key]).to eq('from_string')
    end

    it 'accesses symbol-stored values with string key' do
      expect(hash['symbol_key']).to eq('from_symbol')
    end

    it 'returns nil for missing keys' do
      expect(hash[:missing]).to be_nil
    end
  end

  describe '#has_key? / #key? / #include?' do
    subject(:hash) do
      h = described_class.new
      h['name'] = 'test'
      h
    end

    it 'finds string key via symbol' do
      expect(hash.has_key?(:name)).to be true
    end

    it 'finds string key via string' do
      expect(hash.key?('name')).to be true
    end

    it 'returns false for missing key' do
      expect(hash.include?(:missing)).to be false
    end
  end

  describe '#dig' do
    subject(:hash) do
      described_class.deep_convert({ a: { b: { c: 'deep' } } })
    end

    it 'digs through nested indifferent hashes' do
      expect(hash.dig(:a, :b, :c)).to eq('deep')
    end

    it 'returns nil for missing path' do
      expect(hash.dig(:a, :x, :y)).to be_nil
    end

    it 'returns the value for single key' do
      expect(hash.dig(:a)).to be_a(described_class)
    end
  end

  describe '#fetch' do
    subject(:hash) do
      h = described_class.new
      h['name'] = 'test'
      h
    end

    it 'fetches existing key' do
      expect(hash.fetch(:name)).to eq('test')
    end

    it 'returns default for missing key' do
      expect(hash.fetch(:missing, 'default')).to eq('default')
    end

    it 'yields block for missing key' do
      expect(hash.fetch(:missing) { |k| "#{k} not found" }).to eq('missing not found')
    end

    it 'raises KeyError when no default and no block' do
      expect { hash.fetch(:missing) }.to raise_error(KeyError)
    end
  end
end
