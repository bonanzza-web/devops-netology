# Определяем переменную vm_instances, которая содержит список объектов, описывающих конфигурацию виртуальных машин
variable "vm_instances" {
  type = list(object({
    vm_name = string
    cpu     = number
    ram     = number
    disk    = number
  }))
  default = [
    {
      vm_name = "vm-1"
      cpu     = 2
      ram     = 4
      disk    = 10
    },
    {
      vm_name = "vm-2"
      cpu     = 4
      ram     = 8
      disk    = 20
    }
  ]
}

# Создаем виртуальные машины с использованием мета-аргумента for_each
resource "yandex_compute_instance" "vm-for-each" {
  depends_on = [yandex_compute_instance.develop]
  for_each = { for vm in var.vm_instances : vm.vm_name => vm }

  name = each.value.vm_name

  # Определяем конфигурацию ресурсов виртуальной машины на основе соответствующих значений в списке vm_instances
  resources {
    cores = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  # Определяем ssh-ключ для подключения к виртуальной машине
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }
  network_interface { 
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
}
data "yandex_compute_image" "ubuntu-each" {
  family = var.vm-image-family
}
