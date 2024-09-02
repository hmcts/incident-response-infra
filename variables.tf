variable "env" {
}

variable "product" {
  default = "response"
}

variable "builtFrom" {}

variable "pgsql_storage_mb" {
  default = "32768"
}

variable "location" {
  default = "uksouth"
}

variable "component" {
  default = "incident"
}

variable "mi_env" {
}

variable "create_postgres" {
  description = "Whether to create the PostgreSQL server"
  type        = bool
  default     = true
}