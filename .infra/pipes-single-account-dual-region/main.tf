module "services" {
  source = "./services"
  depends_on = [module.persistence]
  providers = {
    aws.primary = aws.primary
    aws.secondary = aws.secondary
  }
}

module "persistence" {
  source = "./persistence"
  secondary_region = "us-west-2"
}




