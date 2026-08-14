# DynamoDB

variable "global_table_arn" {
  description = "Replicate DynamoDB to another region using the DynamoDB Global Table ARN"
  type        = string
  default     = null
}
