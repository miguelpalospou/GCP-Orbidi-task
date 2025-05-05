provider "google" {
  project = var.project_id
  region  = var.region
}

module "datasets" {
  source           = "./modules/datasets"
  project_id       = var.project_id
  dataset_location = var.location
}

module "function" {
  source              = "./modules/function"
  region              = var.region
  bucket_name         = var.function_bucket_name
  project_id          = var.project_id
  function_zip_source = "weather_function.zip"
}

module "scheduler" {
  source       = "./modules/scheduler"
  region       = var.region
  function_url = module.function.function_url
}

module "iam_roles" {
  source                        = "./modules/iam"
  project_id                    = var.project_id
  admin_user_email              = "miguelpalospou@gmail.com"
  compute_service_account_email = "1081366896145-compute@developer.gserviceaccount.com"
}
