# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'

RSpec.describe 'Google Cloud core types' do
  describe 'GoogleProjectId' do
    let(:type) { Pangea::Resources::Types::GoogleProjectId }

    it 'accepts valid project IDs' do
      expect(type["my-project-123456"]).to eq("my-project-123456")
      expect(type["abcdef"]).to eq("abcdef")
      expect(type["a-long-project-id-with-dashes1"]).to eq("a-long-project-id-with-dashes1")
    end

    it 'accepts Terraform interpolation strings' do
      expect(type["${var.project_id}"]).to eq("${var.project_id}")
      expect(type["${google_project.main.project_id}"]).to eq("${google_project.main.project_id}")
    end

    it 'rejects project IDs that are too short' do
      expect { type["abcde"] }.to raise_error(Dry::Types::ConstraintError)
    end

    it 'rejects project IDs with uppercase letters' do
      expect { type["My-Project-123456"] }.to raise_error(Dry::Types::ConstraintError)
    end

    it 'rejects project IDs starting with a digit' do
      expect { type["1my-project-id"] }.to raise_error(Dry::Types::ConstraintError)
    end

    it 'rejects project IDs ending with a hyphen' do
      expect { type["my-project-"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'GoogleRegion' do
    let(:type) { Pangea::Resources::Types::GoogleRegion }

    it 'accepts valid regions' do
      expect(type["us-central1"]).to eq("us-central1")
      expect(type["europe-west1"]).to eq("europe-west1")
      expect(type["asia-southeast1"]).to eq("asia-southeast1")
      expect(type["africa-south1"]).to eq("africa-south1")
    end

    it 'rejects invalid region names' do
      expect { type["invalid-region"] }.to raise_error(Dry::Types::ConstraintError)
      expect { type["us-central-1"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'GoogleZone' do
    let(:type) { Pangea::Resources::Types::GoogleZone }

    it 'accepts valid zone format' do
      expect(type["us-central1-a"]).to eq("us-central1-a")
      expect(type["europe-west1-b"]).to eq("europe-west1-b")
      expect(type["asia-east1-c"]).to eq("asia-east1-c")
    end

    it 'rejects invalid zone format' do
      expect { type["us-central1"] }.to raise_error(Dry::Types::ConstraintError)
      expect { type["us-central1-ab"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'GoogleMachineType' do
    let(:type) { Pangea::Resources::Types::GoogleMachineType }

    it 'accepts valid machine types' do
      expect(type["e2-micro"]).to eq("e2-micro")
      expect(type["n2-standard-4"]).to eq("n2-standard-4")
      expect(type["c2d-highcpu-112"]).to eq("c2d-highcpu-112")
    end

    it 'rejects machine types starting with uppercase' do
      expect { type["E2-micro"] }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'GoogleLabels' do
    let(:type) { Pangea::Resources::Types::GoogleLabels }

    it 'defaults to empty hash' do
      expect(type[]).to eq({})
    end

    it 'accepts valid label maps' do
      labels = { "env" => "prod", "team" => "platform" }
      expect(type[labels]).to eq(labels)
    end
  end
end
