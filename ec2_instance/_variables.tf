# General

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "service_name" {
  description = "The name of the EC2 instance (e.g., 'bastion')."
  type        = string
}

variable "network_values" {
  description = "The network configuration for the EC2 instance, including VPC and subnets."
  type = object({
    vpc_id             = string
    vpc_cidr_block     = string
    private_subnet_ids = map(string)
    public_subnet_ids  = map(string)
  })
}

# EC2 Instance

variable "ami" {
  description = "The AMI ID to use for the instance. When null, the latest Amazon Linux 2023 for the chosen architecture is used."
  type        = string
  default     = null
}

variable "ami_architecture" {
  description = "The architecture of the Amazon Linux 2023 AMI ('x86_64' or 'arm64'). When null, it is derived from the instance type."
  type        = string
  default     = null
  validation {
    condition     = var.ami_architecture == null || contains(["x86_64", "arm64"], coalesce(var.ami_architecture, "x86_64"))
    error_message = "The value must be one of: [\"x86_64\", \"arm64\"]"
  }
}

variable "instance_type" {
  description = "The instance type to use for the instance."
  type        = string
  default     = "t4g.micro"
}

variable "subnet_placement" {
  description = "The subnet tier the instance is launched into ('public' or 'private')."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private"], var.subnet_placement)
    error_message = "The value must be one of: [\"public\", \"private\"]"
  }
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP to the instance. When null, it follows the subnet placement."
  type        = bool
  default     = null
}

variable "key_name" {
  description = "The name of an existing EC2 key pair (created outside Terraform) to attach to the instance. When null, no key pair is used (access via SSM Session Manager)."
  type        = string
  default     = null
}

variable "volume_size" {
  description = "The size of the root EBS volume to attach to the instance (in GB)."
  type        = string
  default     = "8"
}

variable "volume_type" {
  description = "The type of the root EBS volume to attach to the instance (e.g., 'gp2', 'gp3')."
  type        = string
  default     = "gp3"
}

variable "user_data" {
  description = "The user data script to run on the instance launch."
  type        = string
  default     = null
}

# Security Group

variable "allowed_ssh_cidrs" {
  description = "A list of CIDR blocks allowed to reach the instance on port 22. Empty means no SSH ingress (access via SSM Session Manager)."
  type        = list(string)
  default     = []
}

# IAM

variable "iam_policy_arns" {
  description = "A list of extra IAM managed policy ARNs to attach to the instance role."
  type        = list(string)
  default     = []
}
