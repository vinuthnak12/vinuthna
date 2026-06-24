variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "cluster_name" {
  type    = string
  default = "vinuthna-portfolio"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "kubernetes_version" {
  type    = string
  default = "1.30"
}
