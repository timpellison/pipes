# Define a map of provider aliases and configurations
variable "provider_configurations" {
  type = map(object({
    region   = string
    alias = string
  }))
  default = {
    "us-east-1" = {
      region   = "us-east-1"
      alias = "us-east-1"
    }
    "us-west-2" = {
      region   = "us-west-2"
      alias = "us-west-2"
    }
  }
}