# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pangea::Testing::SynthesisTestHelpers do
  include Pangea::Testing::SynthesisTestHelpers

  describe '#create_synthesizer' do
    it 'returns a TerraformSynthesizer when available' do
      synth = create_synthesizer
      expect(synth).to be_a(TerraformSynthesizer)
    end

    it 'starts with an empty synthesis' do
      synth = create_synthesizer
      result = synth.synthesis
      expect(result).to be_a(Hash)
    end
  end

  describe '#normalize_synthesis' do
    it 'converts symbol keys to string keys via JSON round-trip' do
      input = { resource: { google_vpc: { main: { name: 'test' } } } }
      result = normalize_synthesis(input)

      expect(result).to have_key('resource')
      expect(result['resource']).to have_key('google_vpc')
    end

    it 'preserves string values unchanged' do
      input = { 'key' => 'value' }
      result = normalize_synthesis(input)
      expect(result['key']).to eq('value')
    end

    it 'preserves numeric values' do
      input = { count: 42, ratio: 3.14 }
      result = normalize_synthesis(input)
      expect(result['count']).to eq(42)
      expect(result['ratio']).to eq(3.14)
    end

    it 'preserves boolean values' do
      input = { enabled: true, disabled: false }
      result = normalize_synthesis(input)
      expect(result['enabled']).to eq(true)
      expect(result['disabled']).to eq(false)
    end

    it 'preserves null values' do
      input = { nullable: nil }
      result = normalize_synthesis(input)
      expect(result).to have_key('nullable')
      expect(result['nullable']).to be_nil
    end
  end

  describe '#validate_terraform_structure' do
    it 'accepts a hash with a resource key' do
      result = { 'resource' => { 'google_vpc' => {} } }
      expect { validate_terraform_structure(result, :resource) }.not_to raise_error
    end

    it 'accepts a hash with a data key for data_source' do
      result = { 'data' => { 'google_vpc' => {} } }
      expect { validate_terraform_structure(result, :data_source) }.not_to raise_error
    end

    it 'accepts a hash with an output key for output' do
      result = { 'output' => { 'vpc_id' => {} } }
      expect { validate_terraform_structure(result, :output) }.not_to raise_error
    end

    it 'rejects non-hash input' do
      expect { validate_terraform_structure('not a hash', :resource) }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it 'rejects hash missing required entity key' do
      result = { 'other' => {} }
      expect { validate_terraform_structure(result, :resource) }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe '#validate_resource_structure' do
    let(:valid_result) do
      {
        'resource' => {
          'google_compute_network' => {
            'main' => { 'name' => 'my-vpc' }
          }
        }
      }
    end

    it 'returns the resource config for valid structure' do
      config = validate_resource_structure(valid_result, 'google_compute_network', 'main')
      expect(config).to eq({ 'name' => 'my-vpc' })
    end

    it 'fails when resource type is missing' do
      expect {
        validate_resource_structure(valid_result, 'google_compute_instance', 'main')
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it 'fails when resource name is missing' do
      expect {
        validate_resource_structure(valid_result, 'google_compute_network', 'other')
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe '#validate_required_attributes' do
    it 'passes when all required attributes present' do
      config = { 'name' => 'test', 'cidr' => '10.0.0.0/16' }
      expect {
        validate_required_attributes(config, [:name, :cidr])
      }.not_to raise_error
    end

    it 'fails with descriptive message when attribute missing' do
      config = { 'name' => 'test' }
      expect {
        validate_required_attributes(config, [:name, :missing_attr])
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /missing_attr/)
    end
  end

  describe '#validate_resource_references' do
    it 'extracts terraform interpolation references' do
      result = {
        'resource' => {
          'google_compute_instance' => {
            'main' => {
              'network' => '${google_compute_network.vpc.self_link}'
            }
          }
        }
      }
      refs = validate_resource_references(result)
      expect(refs).to include('${google_compute_network.vpc.self_link}')
    end

    it 'returns empty array when no references exist' do
      result = { 'resource' => { 'test' => { 'main' => { 'name' => 'plain' } } } }
      refs = validate_resource_references(result)
      expect(refs).to be_empty
    end
  end

  describe '#validate_resource_attributes' do
    it 'validates string type attributes' do
      config = { 'name' => 'test' }
      expect {
        validate_resource_attributes(config, { name: String })
      }.not_to raise_error
    end

    it 'validates integer type attributes' do
      config = { 'count' => 5 }
      expect {
        validate_resource_attributes(config, { count: Integer })
      }.not_to raise_error
    end

    it 'validates boolean type attributes' do
      config = { 'enabled' => true }
      expect {
        validate_resource_attributes(config, { enabled: true })
      }.not_to raise_error
    end

    it 'skips attributes not present in config' do
      config = { 'name' => 'test' }
      expect {
        validate_resource_attributes(config, { name: String, missing: Integer })
      }.not_to raise_error
    end
  end

  describe '#validate_dependency_ordering' do
    it 'passes when all dependencies are defined' do
      result = {
        'resource' => {
          'google_compute_network' => {
            'vpc' => { 'name' => 'test' }
          },
          'google_compute_subnetwork' => {
            'sub' => { 'network' => '${google_compute_network.vpc.self_link}' }
          }
        }
      }
      expect { validate_dependency_ordering(result) }.not_to raise_error
    end

    it 'fails when a dependency references undefined resource' do
      result = {
        'resource' => {
          'google_compute_subnetwork' => {
            'sub' => { 'network' => '${google_compute_network.vpc.self_link}' }
          }
        }
      }
      expect { validate_dependency_ordering(result) }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it 'handles resources with no dependencies' do
      result = {
        'resource' => {
          'google_compute_network' => {
            'vpc' => { 'name' => 'test' }
          }
        }
      }
      expect { validate_dependency_ordering(result) }.not_to raise_error
    end

    it 'handles empty resource hash' do
      result = { 'resource' => {} }
      expect { validate_dependency_ordering(result) }.not_to raise_error
    end

    it 'handles missing resource key' do
      result = {}
      expect { validate_dependency_ordering(result) }.not_to raise_error
    end
  end

  describe '#synthesize_and_validate' do
    it 'yields a synthesizer and validates the normalized result' do
      result = synthesize_and_validate(:resource, normalize: true) do
        resource(:test_type, :myname) { name 'hello' }
      end
      expect(result).to have_key('resource')
    end
  end

  describe 'cleanup helpers' do
    it 'provides reset_terraform_synthesizer_state as no-op' do
      expect { reset_terraform_synthesizer_state }.not_to raise_error
    end

    it 'provides cleanup_test_resources as no-op' do
      expect { cleanup_test_resources }.not_to raise_error
    end
  end
end
