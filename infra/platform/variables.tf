variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "container_url" {
  type    = string
  default = "gcr.io/cloudrun/hello"
}