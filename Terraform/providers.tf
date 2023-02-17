provider "aws" {
  shared_credentials_files = ["/home/abdelkhalek97/.aws/credentials"]
  shared_config_files      = ["/home/abdelkhalek97/.aws/config"]
  profile                  = "default"
  region                   = "us-east-1"
}