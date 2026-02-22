# frozen_string_literal: true

require 'pangea/resources/types/core'

module Pangea
  module Resources
    module Types
      # Google Cloud Project ID validation
      # 6-30 chars, lowercase letters, digits, hyphens
      GoogleProjectId = String.constructor { |value|
        next value if value.match?(/\A\$\{.+\}\z/)
        unless value.match?(/\A[a-z][a-z0-9\-]{4,28}[a-z0-9]\z/)
          raise Dry::Types::ConstraintError, "Google Project ID must be 6-30 chars, lowercase letters, digits, hyphens"
        end
        value
      }

      # Google Cloud Region
      GoogleRegion = String.enum(
        'us-central1', 'us-east1', 'us-east4', 'us-east5',
        'us-west1', 'us-west2', 'us-west3', 'us-west4',
        'us-south1',
        'europe-west1', 'europe-west2', 'europe-west3', 'europe-west4',
        'europe-west6', 'europe-west8', 'europe-west9', 'europe-west10',
        'europe-west12', 'europe-north1', 'europe-central2',
        'europe-southwest1',
        'asia-east1', 'asia-east2',
        'asia-northeast1', 'asia-northeast2', 'asia-northeast3',
        'asia-south1', 'asia-south2',
        'asia-southeast1', 'asia-southeast2',
        'australia-southeast1', 'australia-southeast2',
        'northamerica-northeast1', 'northamerica-northeast2',
        'southamerica-east1', 'southamerica-west1',
        'me-west1', 'me-central1', 'me-central2',
        'africa-south1'
      )

      # Google Cloud Zone (format: region-zone like us-central1-a)
      GoogleZone = String.constrained(
        format: /\A[a-z]+-[a-z]+\d+-[a-z]\z/
      )

      # Google Cloud Labels (Hash of String => String)
      GoogleLabels = Hash.map(String, String).default({}.freeze)

      # Google Cloud Machine Type (e.g., e2-micro, n2-standard-2)
      GoogleMachineType = String.constrained(
        format: /\A[a-z][a-z0-9\-]+\z/
      )
    end
  end
end
