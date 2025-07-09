module "message" {
  source = "./modules/storage"

  region = var.region
  bucket_name = var.bucket_name
}
