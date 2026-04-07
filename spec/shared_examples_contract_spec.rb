# frozen_string_literal: true

require 'spec_helper'

module SharedExamplesContractFixtures
  class ContractTestAttrs < Pangea::Resources::BaseAttributes
    attribute :name, Pangea::Resources::Types::Coercible::String
    attribute? :description, Pangea::Resources::Types::Coercible::String.optional
    attribute? :force_destroy, Pangea::Resources::Types::Bool.optional
  end

  module ContractTestModule
    include Pangea::Resources::ResourceBuilder
    define_resource :contract_test_resource,
      attributes_class: ContractTestAttrs,
      outputs: { id: :id, self_link: :self_link },
      map: [:name],
      map_present: [:description],
      map_bool: [:force_destroy]
  end

  class SensitiveTestAttrs < Pangea::Resources::BaseAttributes
    attribute :name, Pangea::Resources::Types::Coercible::String
    attribute? :password, Pangea::Resources::Types::Coercible::String.optional
  end

  module SensitiveTestModule
    include Pangea::Resources::ResourceBuilder
    define_resource :sensitive_test_resource,
      attributes_class: SensitiveTestAttrs,
      outputs: { id: :id },
      map: [:name],
      map_present: [:password]
  end
end

RSpec.describe 'shared_examples contract: a generated pangea resource' do
  describe SharedExamplesContractFixtures::ContractTestModule do
    it_behaves_like 'a generated pangea resource',
      resource_type: :contract_test_resource,
      method: :contract_test_resource,
      required_attrs: { name: 'test-value' },
      expected_outputs: [:id, :self_link],
      sensitive_fields: [],
      immutable_fields: [],
      boolean_fields: [:force_destroy]
  end
end

RSpec.describe 'shared_examples with sensitive and immutable fields' do
  describe SharedExamplesContractFixtures::SensitiveTestModule do
    it_behaves_like 'a generated pangea resource',
      resource_type: :sensitive_test_resource,
      method: :sensitive_test_resource,
      required_attrs: { name: 'test-value' },
      expected_outputs: [:id],
      sensitive_fields: [:password],
      immutable_fields: [:name],
      boolean_fields: []
  end
end
