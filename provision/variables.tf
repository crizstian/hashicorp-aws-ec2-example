variable "region" {
  description = "AWS region"
  default     = "us-east-2"
  type        = string
}

variable "vpc_networks" {
  default = {
    cristian_infra_team_labs = {
      enable             = true
      vpc_cidr           = "10.0.0.0/16"
      private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
      public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
      enable_nat_gateway = false
      sg_pub = {
        standard = ["ssh-tcp", "http-80-tcp"]
        custom = [
          {
            from_port   = 3000
            to_port     = 3000
            protocol    = "tcp"
            description = "User-service ports"
            cidr_blocks = "0.0.0.0/0"
          }
        ]
      }
      sg_priv = {
        standard = ["ssh-tcp"]
        custom   = []
      }
    }
  }
}

variable "tags" {
  default = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "Cristian Ramirez"
  }
}
