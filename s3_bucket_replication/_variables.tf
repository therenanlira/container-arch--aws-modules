# General

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

# Replication

variable "source_bucket" {
  description = "Name and region of the bucket that owns this replication configuration."
  type = object({
    bucket = string
    region = string
  })
}

variable "destination_regions" {
  description = "Regions that receive the replicated objects. Every destination bucket must already exist when this is applied."
  type        = list(string)
  validation {
    condition     = length(var.destination_regions) > 0
    error_message = "At least one destination region is required."
  }
}

variable "replica_modification_sync" {
  description = "Replicate metadata changes (tags, ACLs) made directly on the replicas back to the other buckets."
  type        = bool
  default     = true
}

variable "delete_marker_replication" {
  description = "Replicate delete markers, so a deletion in one region is reflected in the others."
  type        = bool
  default     = true
}

variable "storage_class" {
  description = "Storage class of the replicated objects."
  type        = string
  default     = "STANDARD"
}
