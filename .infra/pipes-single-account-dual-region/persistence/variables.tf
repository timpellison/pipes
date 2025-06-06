variable "primary_region" {
  type = string
  default = "us-east-1"
  description = "Primary region"
  nullable = false
}

variable "secondary_region" {
  type = string
  default = "us-west-2"
  description = "Secondary region"
  nullable = false
}
