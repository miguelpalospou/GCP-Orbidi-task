locals {
  roles = [
    "roles/artifactregistry.admin",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.writer",
    "roles/bigquery.viewer",  # Changed this role to a valid one
    "roles/cloudbuild.builds.editor",
    "roles/cloudfunctions.admin",
    "roles/logging.viewer",
    "roles/logging.logWriter",
    "roles/storage.objectViewer"
  ]

  members = [
    "user:${var.admin_user_email}",
    "serviceAccount:${var.compute_service_account_email}"
  ]

  bindings = flatten([
    for role in local.roles : [
      for member in local.members : {
        role   = role
        member = member
      }
    ]
  ])
}
