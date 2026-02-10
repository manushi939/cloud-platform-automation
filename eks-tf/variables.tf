variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "k8s_version" {
  type    = string
  default = "1.32"
}

variable "cluster_iam_role_arn" {
  type = string
}

variable "node_iam_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node-subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_groups" {
  description = "List of custom node groups"
  type = list(object({
    name                     = string
    launch_template_id       = string
    launch_template_version  = string
    desired_size             = number
    min_size                 = number
    max_size                 = number
    labels                   = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
}
