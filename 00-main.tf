#---------------------------------------------------------------------------------------------------
# Terraform CHANGELOG : https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md
# Provider AWS CHANGELOG : https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md
#---------------------------------------------------------------------------------------------------
 
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "4.29.0"
    }

    aws-us = {
      source                = "hashicorp/aws"
      version               = "4.29.0"
    }
  }
}

#---------------------------------------------------------------------------------------------------
# Synthétisation des variables
#---------------------------------------------------------------------------------------------------
locals {
  prefix_name = "i9i-app"
  bucket    = coalesce(var.bucket, local.prefix_name)
  role_name = "${local.bucket}-rep-src"
  name              = "edh-nonprod"
  certificate_arn   = ""
  dns               = ""
}
#---------------------------------------------------------------------------------------------------
data "aws_caller_identity" "this" {
}

provider "aws" {
  alias     = "aws"
  region    = "eu-west-3"
}

provider "aws" {
  alias     = "aws-us"
  region    = "us-east-1"
}