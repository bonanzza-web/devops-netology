terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.89.0"
    }
    template = {
      source = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
  required_version = ">=0.13"
  
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket = "tfstate-develop-netology"
    region = "ru-central1"
    key = "terraform.tfstate"
    
    skip_region_validation = true
    skip_credentials_validation = true

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gi22rcstndoop7nled/etnn06m2e4hgctg5lij4"
    dynamodb_table = "tflock-develop" 
}
}


provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}


module "vpc" {
  source = "./vpc"
  vpc_name = "my-vpc"
  subnet_name = "my-subnet"
  zone = "ru-central1-a"
  subnet_cidr_block = "10.0.1.0/24"
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=v1.0.0"
  env_name        = "develop"
  network_id      = module.vpc.vpc_id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [module.vpc.subnet_id]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }

}


#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")

 vars = {
    ssh_key = local.ssh_key
  }
}

