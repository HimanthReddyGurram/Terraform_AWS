terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# our default region is in congif file and cli keys in credentials file in the following directory
# provider "aws" {
#   shared_config_files      = ["~/.aws/config"]
#   shared_credentials_files = ["~/.aws/credentials"]
# }

provider "aws" {
  region     = "ap-southeast-1"
  access_key = "AKIAQUVAFLXY6LFTDEX4"
  secret_key = "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"
}