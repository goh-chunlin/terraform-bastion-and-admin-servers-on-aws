## Define Common variables #################################

variable "aws_region" {
  default     = null 
  type        = string
  description = "AWS region"
}

variable "resource_prefix" {
  default     = null
  type        = string
  description = "Resource prefix"
}
