resource "yandex_alb_backend_group" "this" {
  name = "${local.preffix}-alb-back"

  http_backend {
    name             = "${local.preffix}-http-backend"
    weight           = 1
    port             = "${var.http_backend_port}"
    target_group_ids = [yandex_compute_instance_group.this.application_load_balancer.0.target_group_id]
    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout  = "${var.alb_backend_healthcheck.timeout}"
      interval = "${var.alb_backend_healthcheck.interval}"
      healthcheck_port = "${var.alb_backend_healthcheck.port}"
      http_healthcheck {
        path = "${var.alb_backend_healthcheck.path}"
      }
    }
  }
  depends_on = [yandex_compute_instance_group.this]
}

resource "yandex_alb_http_router" "this" {
  name   = "${local.preffix}-http-router"
}

resource "yandex_alb_virtual_host" "this" {
  name           = "${local.preffix}-virtual-host"
  http_router_id = yandex_alb_http_router.this.id
  route {
    name = "${local.preffix}-alb-vh-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.this.id
        timeout          = "3s"
        upgrade_types    = ["websocket"]
      }
    }
  }
  depends_on = [
    yandex_compute_instance_group.this,
    yandex_alb_backend_group.this,
    yandex_alb_http_router.this
  ]
}

resource "yandex_alb_load_balancer" "this" {
  name = "${local.preffix}-alb"

  network_id = "${yandex_vpc_network.this.id}"

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = "${yandex_vpc_subnet.this["ru-central1-a"].id}"

    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = "${yandex_vpc_subnet.this["ru-central1-b"].id}"

    }
    location {
      zone_id   = "ru-central1-c"
      subnet_id = "${yandex_vpc_subnet.this["ru-central1-c"].id}"

    }
  }

  listener {
    name = "${local.preffix}-alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = ["${var.alb_listener_port}"]
    }
    http {
      handler {
        http_router_id = "${yandex_alb_http_router.this.id}"
      }
    }
  }
  depends_on = [
    yandex_alb_http_router.this,
    yandex_alb_virtual_host.this
  ]
}
