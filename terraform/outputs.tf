data "yandex_compute_instance_group" "this" {
  instance_group_id = "${yandex_compute_instance_group.this.id}"
}

output "instance_external_ip" {
  value = "${data.yandex_compute_instance_group.this.instances.*.network_interface.0.nat_ip_address}"
}

output "private_key" {
  value     = var.public_ssh_key_path == "" ? tls_private_key.yandex_ssh_key[0].private_key_pem : ""
  sensitive = true
}

output "alb_load_balancer_name" {
  description = "ALB name"
  value       = "${yandex_alb_load_balancer.this.name}"
}

output "alb_load_balancer_public_ips" {
  description = "ALB public IPs"
  value       = yandex_alb_load_balancer.this.listener[0].endpoint[0].address[0].external_ipv4_address
}
