variable "availability_zones" {
  type        = list(string)
  description = "AWS Availability Zones"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1e",
  ]
}

variable "key_pair" {
  description = "AWS EC2 Key Pair Pem"
  default     = "devsecops"
}

variable "ami" {
  description = "Amazon Linux 2 AMI x86"
  default     = "ami-0b5eea76982371e91"
}

variable "instance_type" {
  description = "AWS Instance Type"
  default     = "t3.micro"
}

variable "iam_profile" {
  description = "Name of AWS IAM Profile"
  default     = "ec2ECSRole"
}

variable "asg_min" {
  description = "Min Instances"
  default     = 1
}

variable "asg_max" {
  description = "Max Instances"
  default     = 1
}

variable "asg_desired" {
  description = "AWS Desired capacity for ASG"
  default     = 1
}

variable "docker_img_name" {
  type        = string
  description = "Name of the docker image being deployed"
  default     = "t6a3k8e1/aws-devsecops-demo"
}

variable "docker_img_tag" {
  type        = string
  description = "The docker image TAG being deployed"
  default     = "latest"
}

variable "ecs_desired_count" {
  description = "Number of desired ECS Tasks to deploy"
  default     = 1
}

