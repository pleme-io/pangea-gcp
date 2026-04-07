# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Pangea::Resources::Google module hierarchy' do
  it 'defines the top-level Pangea module' do
    expect(defined?(Pangea)).to eq('constant')
  end

  it 'defines Pangea::Resources' do
    expect(defined?(Pangea::Resources)).to eq('constant')
  end

  it 'defines Pangea::Resources::Google' do
    expect(defined?(Pangea::Resources::Google)).to eq('constant')
  end

  it 'defines Pangea::Resources::Google::Types' do
    expect(defined?(Pangea::Resources::Google::Types)).to eq('constant')
  end

  it 'has Google as a Module (not Class)' do
    expect(Pangea::Resources::Google).to be_a(Module)
    expect(Pangea::Resources::Google).not_to be_a(Class)
  end

  it 'has Google::Types as a Module' do
    expect(Pangea::Resources::Google::Types).to be_a(Module)
  end

  it 'can be aliased at the top level for convenience' do
    google_mod = Pangea::Resources::Google
    expect(google_mod).to be_a(Module)
    expect(google_mod.name).to eq('Pangea::Resources::Google')
  end
end
