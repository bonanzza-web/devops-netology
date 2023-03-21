###vm_web

### Image
variable "vm_web_image_name" {
  type        = string
  description = "Image name"
  default     = "ubuntu-2004-lts"
}

###Cores
variable "vm_web_cores_quantity" {
  type        = number
  description = "Cores quantity"
  default     = 2
}

###Memory
variable "vm_web_memory_quantity" {
  type        = number
  description = "Memory quantity"
  default     = 1
}

###Core_fraction
variable "vm_web_core_fraction" {
  type        = number
  description = "Core_fraction value"
  default     = 5
}

###For locals
###VM env
variable "vm_env" {
  type        = string
  description = "VM name"
  default     = "netology-develop-platform"
}

###WEb role
variable "web_role" {
  type        = string
  description = "WEB name"
  default     = "web"
}

###db role
variable "db_role" {
  type        = string
  description = "DB name"
  default     = "db"
}

###Maps

variable "vm_web_resources" {
  type = map
  default = {
    cores = 2
    memory = 1
    core_fraction = 5
  }
}

variable "vm_db_resources" {
  type = map
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 20
  }
}

variable "vm_ssh" {
  type = map
  default = {
    serial-port-enable = 1
    ssh-keys           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRWa6iVxkFB+h+gZqKfCg7R+ZJFnYdUA1liaAAv0MpByHj1gH4kYYcPtV5qZeBk3nHN2iTDTgmruKKqSXFVUD0w0VZT9xLbIXqnGK1CYuGaTsv7EuxY/78/1na6D66uVWvRTK+Nqh5bOUiomEX4QPhtSp183Klgy1x2o0gEKtVTxlOlttIZ9aY0vVXq5x7J1QTzCq/DDSQC5USkC4Tok/y9fLMjw2LyGtpgnOoZtWIbt/uMN0v3cfR925Ow7ZKNSsKK26B5A3hFyL/zje07hnQl7+ABUUbZMopBxLyujybAMD2oUTzrGvBBLunA7h8lvj3gyqWDbMSuBWXWJbOIi6TSWQdFG2DslBj4eMFt7Hf/EeUvQPtHEbU/RNnaBnTBn/mm8xcQSj43McqGgq4HGvJ6pwthZrlF03Lc4/+OtcLONIb7tsyin0cKLiec4mT5eIMy81ES7Al8/z2ttMrisWmaWHMupKA3wGXWV6SCygmmDbvmV4rxPVrR2M8hAoJK5M="

  }
}