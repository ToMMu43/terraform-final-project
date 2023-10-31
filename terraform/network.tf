resource "yandex_vpc_network" "this" {
  name = "slurm-network"
}

resource "yandex_vpc_subnet" "this" {
  for_each = toset(var.az)

  name           = "test-${each.value}"
  zone           = each.value
  network_id     = var.vpc_id != "" ? var.vpc_id : yandex_vpc_network.this.id
  v4_cidr_blocks = var.cidr_blocks[index(var.az, each.value)]
  labels         = var.labels
}

