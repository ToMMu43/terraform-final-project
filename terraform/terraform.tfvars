terraform_project = "/home/tommu/Documents/_Courses/slurm/DevOps Upgrade/terraform/slurm-tf-final-project/terraform"
public_ssh_key_path = "~/.ssh/id_rsa.pub"
#public_ssh_key_path = ""

image_family = "slurm-images"
vm_name = "test"

resources = ({
  cpu = 2
  disk = 10
  memory = 4
})

labels = {
  "app" = "tf-practicum"
  "team" = "slurm"
}

alb_listener_port = 80

alb_backend_healthcheck = ({
  timeout = "1s"
  interval = "1s"
  port = 80
  path = "/"
})

http_backend_port = 80

cidr_blocks = [
  ["10.10.0.0/24"],
  ["10.20.0.0/24"],
  ["10.30.0.0/24"],
]
