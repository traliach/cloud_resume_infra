terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket  = "achille-tf-state"
    key     = "cloud-resume/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "cloud-resume"
      ManagedBy = "terraform"
      Env       = "production"
    }
  }
}

# Alias provider locked to us-east-1 — required for ACM + CloudFront
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "cloud-resume"
      ManagedBy = "terraform"
      Env       = "production"
    }
  }
}
