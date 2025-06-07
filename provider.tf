terraform {
	required_version = "~> 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}