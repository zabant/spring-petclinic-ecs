variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_account_id" {
  type    = string
  default = "607828299252"
}

variable "app_name" {
  type    = string
  default = "petclinic"
}

variable "DEPLOY_CONTAINER_VERSION" {
  type = string
}