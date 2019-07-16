provider "aws" {
  region                  = "us-east-1"
  alias                   = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

provider "aws" {
  region                  = "us-west-1"
  alias                   = "us-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

provider "aws" {
  region                  = "us-west-2"
  alias                   = "us-west-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

