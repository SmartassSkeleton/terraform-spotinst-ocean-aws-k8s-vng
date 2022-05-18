terraform {
  required_providers {
    spotinst = {
      source = "spotinst/spotinst"
    }
  }
}

provider "spotinst" {
  token   = "redacted"
  account = "redacted"
}

module "ocean-aws-k8s" {
  source  = "spotinst/ocean-aws-k8s/spotinst"
  ...
}

## Create Ocean Virtual Node Group (launchspec) ##
module "ocean-aws-k8s-vng_stateless" {
  source = "spotinst/ocean-aws-k8s-vng/spotinst"

  cluster_name  = "Example-EKS"
  ocean_id      = module.ocean-aws-k8s.ocean_id

  # Name of VNG in Ocean
  name = "Worker-Nodes"

  # Add Labels or taints
  labels = [{key="type",value="worker"}]
  taints = [{key="type",value="worker",effect="NoSchedule"}]
}

## Create additional Ocean Virtual Node Group (launchspec) ##
module "ocean-aws-k8s-vng_gpu" {
  source = "spotinst/ocean-aws-k8s-vng/spotinst"

  cluster_name  = "Example-EKS"
  ocean_id      = module.ocean-aws-k8s.ocean_id

  # Name of VNG in Ocean
  name          = "GPU"
  #ami_id       = ""

  # Add Labels or taints
  labels = [{key="type",value="gpu"}]
  taints = [{key="type",value="gpu",effect="NoSchedule"}]

  #instance_types = ["g4dn.xlarge","g4dn.2xlarge"] # Limit VNG to specific instance types
  spot_percentage = 50 # Change the spot %
}

module "ocean-controller" {
  source = "spotinst/ocean-controller/spotinst"

  # Credentials.
  spotinst_token   = "redacted"
  spotinst_account = "redacted"

  # Configuration.
  cluster_identifier = "cluster_name"
}