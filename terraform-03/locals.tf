locals {
  ssh_key = file("~/.ssh/id_rsa.pub")
}

locals {
  webservers1 = yandex_compute_instance.vm-for-each
  webservers2 = yandex_compute_instance.develop
}