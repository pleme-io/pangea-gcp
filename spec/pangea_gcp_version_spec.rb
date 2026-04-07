# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PangeaGcp do
  describe 'VERSION' do
    it 'is defined' do
      expect(defined?(PangeaGcp::VERSION)).to eq('constant')
    end

    it 'is a non-empty string' do
      expect(PangeaGcp::VERSION).to be_a(String)
      expect(PangeaGcp::VERSION).not_to be_empty
    end

    it 'follows semver format (MAJOR.MINOR.PATCH)' do
      expect(PangeaGcp::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end

    it 'is frozen to prevent accidental mutation' do
      expect(PangeaGcp::VERSION).to be_frozen
    end

    it 'survives mutation attempts on the frozen string' do
      expect { PangeaGcp::VERSION << '-modified' }.to raise_error(FrozenError)
    end
  end
end
