terraform {
  backend "s3" {
    bucket  = "terraform-trackit"
    key     = "alarms/"
    region  = "us-west-2"
    encrypt = "true"
  }
}

