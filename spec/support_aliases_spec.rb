# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'spec/support backwards compatibility aliases' do
  describe 'SynthesisTestHelpers alias' do
    it 'is defined at top level' do
      expect(defined?(SynthesisTestHelpers)).to eq('constant')
    end

    it 'points to Pangea::Testing::SynthesisTestHelpers' do
      expect(SynthesisTestHelpers).to eq(Pangea::Testing::SynthesisTestHelpers)
    end
  end

  describe 'MockTerraformSynthesizer alias' do
    it 'is defined at top level' do
      expect(defined?(MockTerraformSynthesizer)).to eq('constant')
    end

    it 'points to Pangea::Testing::MockTerraformSynthesizer' do
      expect(MockTerraformSynthesizer).to eq(Pangea::Testing::MockTerraformSynthesizer)
    end

    it 'can be instantiated and produces empty synthesis' do
      mock = MockTerraformSynthesizer.new
      expect(mock.synthesis).to eq({})
    end
  end

  describe 'MockResourceReference alias' do
    it 'is defined at top level' do
      expect(defined?(MockResourceReference)).to eq('constant')
    end

    it 'points to Pangea::Testing::MockResourceReference' do
      expect(MockResourceReference).to eq(Pangea::Testing::MockResourceReference)
    end
  end
end
