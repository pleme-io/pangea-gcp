# frozen_string_literal: true
require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/google_cloud_run_service/resource'

RSpec.describe 'google_cloud_run_service synthesis' do
  include Pangea::Resources::Google

  let(:synthesizer) { TerraformSynthesizer.new }

  it_behaves_like 'a pangea resource',
    resource_type: :google_cloud_run_service,
    provider: Pangea::Resources::Google,
    required_attrs: { name: 'test-svc', location: 'us-central1', template: { spec: { containers: [{ image: 'test' }] } } },
    expected_outputs: [:id, :status]

  it 'synthesizes with minimal attributes' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_cloud_run_service(:test, { name: "my-service", location: "us-central1", template: { spec: { containers: [{ image: "gcr.io/my-project/my-image" }] } } })
    end
    result = synthesizer.synthesis
    expect(result[:resource][:google_cloud_run_service][:test]).to be_a(Hash)
  end

  it 'synthesizes with traffic splitting and metadata' do
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      google_cloud_run_service(:full, {
        name: "api-service",
        project: "my-project",
        location: "us-central1",
        template: {
          spec: {
            containers: [{
              image: "gcr.io/my-project/api:v2",
              resources: { limits: { cpu: "2", memory: "1Gi" } },
              env: [{ name: "DB_HOST", value: "10.0.0.1" }],
              ports: [{ container_port: 8080 }]
            }],
            container_concurrency: 80,
            timeout_seconds: 300,
            service_account_name: "sa@my-project.iam.gserviceaccount.com"
          },
          metadata: {
            annotations: { "autoscaling.knative.dev/maxScale" => "10" }
          }
        },
        traffic: [
          { percent: 90, latest_revision: true },
          { percent: 10, revision_name: "api-service-00001-abc" }
        ],
        metadata: {
          annotations: { "run.googleapis.com/ingress" => "all" }
        },
        autogenerate_revision_name: true
      })
    end
    result = synthesizer.synthesis
    svc = result[:resource][:google_cloud_run_service][:full]
    expect(svc[:traffic]).to be_a(Array)
    expect(svc[:traffic].length).to eq(2)
    expect(svc[:autogenerate_revision_name]).to eq(true)
  end

  it 'raises error when required template is missing' do
    expect {
      Google::Types::CloudRunServiceAttributes.new(
        name: "test", location: "us-central1"
      )
    }.to raise_error(Dry::Struct::Error)
  end

  it 'returns a ResourceReference with status output' do
    ref = nil
    synthesizer.instance_eval do
      extend Pangea::Resources::Google
      ref = google_cloud_run_service(:ref_test, { name: "ref-svc", location: "us-central1", template: { spec: { containers: [{ image: "nginx" }] } } })
    end
    expect(ref.type).to eq('google_cloud_run_service')
    expect(ref.outputs[:status]).to eq("${google_cloud_run_service.ref_test.status}")
  end
end
