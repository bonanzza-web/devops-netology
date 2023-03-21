output "netology-develop-platform-web_external_ip" {
  value = yandex_compute_instance.platform.network_interface.0.nat_ip_address
}

output "netology-develop-platform-db_external_ip" {
  value = yandex_compute_instance.platform2.network_interface.0.nat_ip_address
}
