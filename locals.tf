locals {
  default_tags = merge(var.tags, {
    environment = var.environment
    managed-by  = "terraform"
    project     = "azure-platform-landing-zone"
  })
}
