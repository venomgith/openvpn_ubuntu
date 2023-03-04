variable "region" {
  description = "region user in AWS"
  type        = string
  default     = "eu-central-1"
}

variable "ami" {
  description = "ami value"
  type        = string
  default     = "ami-0d1ddd83282187d18"
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform" = "TRUE",
    "Owner"     = "Ellington"
  }
}

