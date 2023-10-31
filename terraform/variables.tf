variable "folder_id" {
  type = string
  description = "folder id for current project"
}

variable "image_name" {
  type = string
  description = "name for packer building image"
}

variable "image_tag" {
  type = string
  description = "tag for packer building image"
}

variable "image_family" {
  type = string
  description = "Family of Image for create VM"
}

variable "terraform_project" {
  type = string
  description = "path to terraform project"
}

variable "vm_count" {
  type = number
  description = "Number of VM"
}

variable "labels" {
  type = map(string)
  description = "Lables to add to resources"
}

variable "resources" {
  type = object({
    disk = number
    memory = number
    cpu = number
  })
}

variable "cidr_blocks" {
  type = list(list(string))
  description = "List of lists of IPv4 cidr blocks for subnets"
}

variable "vpc_id" {
  type = string
  default = ""
  description = "VPC ID"
}

variable "vm_name" {
  type = string
  description = "name of VM"
}

variable "alb_listener_port" {
  type = number
  description = "listener port for app load balancer"
}

variable "http_backend_port" { 
  type = number
  description = "Http backend port for alb backend group"
}

variable "alb_backend_healthcheck" {
  type = object ({
    timeout = string
    interval = string
    port = number
    path = string
  })
  description = "vars for alb healthcheck"
}

variable "public_ssh_key_path" {
  type = string
  description = "path to ssh key"
}

variable "az" {
  type = list(string)
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
}
