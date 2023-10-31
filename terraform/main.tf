data "yandex_compute_image" "this" {
  name = "${var.image_name}-${var.image_tag}"
}

locals {
  preffix = "slurm"
}

resource "yandex_iam_service_account" "this" {
  name        = "${local.preffix}-sa"
  description = "this sa for work with instance group"
  depends_on  = ["yandex_vpc_subnet.this"]
}

resource "yandex_resourcemanager_folder_iam_binding" "this" {
  folder_id   = "${var.folder_id}"
  role        = "editor"
  members     = [
    "serviceAccount:${yandex_iam_service_account.this.id}",
  ]
  depends_on = ["yandex_iam_service_account.this", "yandex_vpc_subnet.this"]
}

resource "yandex_compute_instance_group" "this" {
  name               = "${local.preffix}-ig"
  service_account_id = "${yandex_iam_service_account.this.id}"
  folder_id          = "${var.folder_id}"

  instance_template {
    platform_id = "standard-v1"
    resources {
      cores  = "${var.resources.cpu}"
      memory = "${var.resources.memory}"
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.this.id
        size     = "${var.resources.disk}"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.this.id}"
      subnet_ids = [
        "${yandex_vpc_subnet.this["ru-central1-a"].id}",
        "${yandex_vpc_subnet.this["ru-central1-b"].id}",
        "${yandex_vpc_subnet.this["ru-central1-c"].id}"
      ]
      nat        = true
    }

    metadata = {
      ssh-keys = var.public_ssh_key_path == "" ? "yc-user:${tls_private_key.yandex_ssh_key[0].public_key_openssh}" : "yc-user:${file(var.public_ssh_key_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = "${var.vm_count}"
    }
  }

  allocation_policy {
    zones = "${var.az}"
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  health_check {
    interval            = "2"
    timeout             = "1"
    healthy_threshold   = "5"
    unhealthy_threshold = "5"
    http_options {
      port = "80"
      path = "/"
    }
  }

  application_load_balancer {
    target_group_name = "${local.preffix}-alb-tg"
  }

  depends_on = ["yandex_resourcemanager_folder_iam_binding.this", "yandex_iam_service_account.this", "yandex_vpc_subnet.this"]
}
