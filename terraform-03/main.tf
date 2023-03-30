resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/inventory.tftpl",

    { webservers1 =  yandex_compute_instance.vm-for-each, webservers2 = yandex_compute_instance.develop    }  )

  filename = "${abspath(path.module)}/hosts.cfg"
}