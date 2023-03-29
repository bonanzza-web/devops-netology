###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
# variable "public_key" {
#   description = "Public key for SSH access"
#   type        = string
#   default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRWa6iVxkFB+h+gZqKfCg7R+ZJFnYdUA1liaAAv0MpByHj1gH4kYYcPtV5qZeBk3nHN2iTDTgmruKKqSXFVUD0w0VZT9xLbIXqnGK1CYuGaTsv7EuxY/78/1na6D66uVWvRTK+Nqh5bOUiomEX4QPhtSp183Klgy1x2o0gEKtVTxlOlttIZ9aY0vVXq5x7J1QTzCq/DDSQC5USkC4Tok/y9fLMjw2LyGtpgnOoZtWIbt/uMN0v3cfR925Ow7ZKNSsKK26B5A3hFyL/zje07hnQl7+ABUUbZMopBxLyujybAMD2oUTzrGvBBLunA7h8lvj3gyqWDbMSuBWXWJbOIi6TSWQdFG2DslBj4eMFt7Hf/EeUvQPtHEbU/RNnaBnTBn/mm8xcQSj43McqGgq4HGvJ6pwthZrlF03Lc4/+OtcLONIb7tsyin0cKLiec4mT5eIMy81ES7Al8/z2ttMrisWmaWHMupKA3wGXWV6SCygmmDbvmV4rxPVrR2M8hAoJK5M="
# }

variable "vm-image-family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "Image family"
}