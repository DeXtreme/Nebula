variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr" {
    type = string
    description = "VPC cidr"
    default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  description = "AZs to use"
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type = list(string)
  description = "Public subnet cidrs"
  default = ["10.0.0.0/24","10.0.1.0/24"]
}

variable "private_subnets" {
  type = list(string)
  description = "Private subnet cidrs"
  default = ["10.0.2.0/24"]
}

variable "database_subnets" {
  type = list(string)
  description = "Database subnet cidrs"
  default = ["10.0.3.0/24","10.0.4.0/24"]
}


