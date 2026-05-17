terraform {
  required_version = "1.15.3"

  backend "s3" {
    bucket       = "tfstate-091512051921-ap-northeast-1-an"
    key          = "terraform.tfstate"
    region       = "ap-northeast-1"
    profile      = "org"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.45.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "org"
}
