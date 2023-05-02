variable "ami" {
  type        = string
  description = "The id of the Amazon Machine Image (AMI) to use for the EC2 instance."
  
  validation {
    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
    error_message = "The ami value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  type        = string
  description = "The type of the instance, such as t2.micro."
}

variable "server_name" {
  type        = string
  description = "Name of the EC2 instance."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet that the instance will sit in."
}

variable "is_in_public_subnet" {
  type        = bool
  description = "True if the subnet is a public subnet, false otherwise."
}

variable "key_name" {
  type        = string
  description = "Name of the key pair to securely connect to the instance."
}

variable "security_group" {
  type        = object({
    name        = string
    description = string
  })
  description = "Info of the security group that control the traffic for the instance."
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC the instance will be positioned at."
}

variable "user_data" {
  type        = string
  description = "Commands or a command script to run when instance is launched."
  default = ""
}