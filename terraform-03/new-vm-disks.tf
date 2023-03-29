resource "yandex_compute_instance" "vm-for-disks" {
  name        = "netology-develop-platform-web-new-vm-for-disks"
  platform_id = "standard-v1"
  

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = "network-hdd"
      size = 5
    }   
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk.*.id

    content {
      disk_id = secondary_disk.value
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }

  scheduling_policy { preemptible = true }

  network_interface { 
    # subnet_id = yandex_vpc_subnet.develop.id
    subnet_id =     "e9b1e28nr3lijhhf9701"
    nat       = true
    security_group_ids = [
    "enplfb6uudtnq1ak9gk6"
  ]
  }
  
  allow_stopping_for_update = true
}
data "yandex_compute_image" "ubuntu-new" {
  family = var.vm-image-family
}