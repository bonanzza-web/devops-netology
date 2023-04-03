locals {
  ssh_key = file("~/.ssh/id_rsa.pub")
}

locals {
  vpc_zone = "ru-central1-a"
}