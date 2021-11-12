provider "aws" {
  region = var.region
}

provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "region-master"
}