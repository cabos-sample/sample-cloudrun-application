module "sample_app_naming" {
  source = "../_module/naming"
  role   = "sample-app"
}

resource "google_project_service" "cloudrun" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_run_service" "service" {
  project  = var.project_id
  name     = module.sample_app_naming.name
  location = var.region

  template {
    spec {
      containers {
        image = var.container_url
        env {
          name  = "PROJECT_NAME"
          value = var.project_id
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  depends_on = [
    google_project_service.cloudrun
  ]
}

resource "google_cloud_run_service_iam_binding" "noauth" {
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_service.service.name

  role = "roles/run.invoker"
  members = ["allUsers"]
} 
