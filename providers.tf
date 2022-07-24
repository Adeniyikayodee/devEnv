terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  // shared_config_files      = ["/Users/tf_user/.aws/conf"]
  //shared_credentials_file = "~/.aws/credentials"
  profile = "default"
}