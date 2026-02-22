# frozen_string_literal: true

module Pangea
  module Resources
    # Aggregator module that includes all Google Cloud resource modules.
    # Each resource file reopens this module and includes itself,
    # so by the time this file is loaded all resource modules are
    # already mixed in. This file exists as a single entry point
    # for consumers who want `include Pangea::Resources::Google`.
    module Google
      include GoogleProject
      include GoogleComputeNetwork
      include GoogleComputeSubnetwork
      include GoogleComputeFirewall
      include GoogleComputeInstance
      include GoogleComputeAddress
      include GoogleComputeDisk
      include GoogleStorageBucket
      include GoogleStorageBucketIamMember
      include GoogleContainerCluster
      include GoogleContainerNodePool
      include GoogleSqlDatabaseInstance
      include GoogleSqlDatabase
      include GoogleSqlUser
      include GoogleDnsManagedZone
      include GoogleDnsRecordSet
      include GooglePubsubTopic
      include GooglePubsubSubscription
      include GoogleCloudRunService
      include GoogleServiceAccount
      include GoogleProjectIamMember
      include GoogleSecretManagerSecret
      include GoogleSecretManagerSecretVersion
      include GoogleRedisInstance
      include GoogleArtifactRegistryRepository
    end
  end
end
