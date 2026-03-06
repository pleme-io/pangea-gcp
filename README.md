# pangea-gcp

Google Cloud provider bindings for the Pangea infrastructure DSL.

## Overview

Provides 25 typed Terraform resource functions for GCP, covering projects, Compute Engine,
GKE, Cloud SQL, Cloud Storage, DNS, Pub/Sub, Cloud Run, IAM, Secret Manager, Redis,
and Artifact Registry. Each resource uses Dry::Struct validation and compiles to
Terraform JSON via terraform-synthesizer. Built on pangea-core.

## Installation

```ruby
gem 'pangea-gcp', '~> 0.1'
```

## Usage

```ruby
require 'pangea-gcp'

template :my_infra do
  provider :google do
    project "my-project"
    region  "us-central1"
  end

  network = google_compute_network(:main, { name: "my-vpc", auto_create_subnetworks: false })
  google_compute_subnetwork(:nodes, { name: "nodes", network: network.id, ip_cidr_range: "10.0.0.0/24", region: "us-central1" })
end
```

## Development

```bash
nix develop
bundle exec rspec
```

## License

Apache-2.0
