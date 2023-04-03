# Домашнее задание к занятию "Продвинутые методы работы с Terraform"

### Цель задания

1. Научиться использовать модули.
2. Отработать операции state.
3. Закрепить пройденный материал.


### Чеклист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент yandex CLI
3. Исходный код для выполнения задания расположен в директории [**04/src**](https://github.com/netology-code/ter-homeworks/tree/main/04/src).
4. Любые ВМ, использованные при выполнении задания должны быть прерываемыми, для экономии средств.

------

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания ВМ с помощью remote модуля.
2. Создайте 1 ВМ, используя данный модуль. В файле cloud-init.yml необходимо использовать переменную для ssh ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание что ssh-authorized-keys принимает в себя список, а не строку!
3. Добавьте в файл cloud-init.yml установку nginx.
4. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```.

Ответ: ![alt text](https://github.com/bonanzza-web/devops-netology/blob/terraform-04/terraform-04/image/04-1.png) 

------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля. например: ```ru-central1-a```.
2. Модуль должен возвращать значения vpc.id и subnet.id
3. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet, созданным модулем.
4. Сгенерируйте документацию к модулю с помощью terraform-docs.    
 
Пример вызова:
```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.vpc](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | n/a | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
```

### Задание 3
1. Выведите список ресурсов в стейте.
2. Удалите из стейта модуль vpc.
3. Импортируйте его обратно. Проверьте terraform plan - изменений быть не должно.
Приложите список выполненных команд и вывод.  

Ответ:  

```
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform state list
data.template_file.cloudinit
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]
module.vpc.yandex_vpc_network.vpc
module.vpc.yandex_vpc_subnet.subnet
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform state show module.vpc.yandex_vpc_subnet.subnet
# module.vpc.yandex_vpc_subnet.subnet:
resource "yandex_vpc_subnet" "subnet" {
    created_at     = "2023-04-03T11:17:34Z"
    folder_id      = "b1gch5k5t1moacc510m8"
    id             = "e9bk6v5p1fvl1ruqkk9q"
    labels         = {}
    name           = "my-subnet"
    network_id     = "enpbbrvv847bna3b33hi"
    v4_cidr_blocks = [
        "10.0.1.0/24",
    ]
    v6_cidr_blocks = []
    zone           = "ru-central1-a"
}
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform state show module.vpc.yandex_vpc_network.vpc
# module.vpc.yandex_vpc_network.vpc:
resource "yandex_vpc_network" "vpc" {
    created_at = "2023-04-03T11:17:32Z"
    folder_id  = "b1gch5k5t1moacc510m8"
    id         = "enpbbrvv847bna3b33hi"
    labels     = {}
    name       = "my-vpc"
    subnet_ids = []
}
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform state rm 'module.vpc.yandex_vpc_subnet.subnet'
Removed module.vpc.yandex_vpc_subnet.subnet
Successfully removed 1 resource instance(s).
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform state rm 'module.vpc.yandex_vpc_network.vpc'
Removed module.vpc.yandex_vpc_network.vpc
Successfully removed 1 resource instance(s).
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform state list
data.template_file.cloudinit
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform import 'module.vpc.yandex_vpc_network.vpc' enpbbrvv847bna3b33hi
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=19ac89b2133c2463f59298fddc8584693c2e7ecb1fc435623eeb481c2253ccbd]
module.vpc.yandex_vpc_network.vpc: Importing from ID "enpbbrvv847bna3b33hi"...
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc.yandex_vpc_network.vpc: Import prepared!
  Prepared yandex_vpc_network for import
module.vpc.yandex_vpc_network.vpc: Refreshing state... [id=enpbbrvv847bna3b33hi]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 0s [id=fd8tckeqoshi403tks4l]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform import 'module.vpc.yandex_vpc_subnet.subnet' e9bk6v5p1fvl1ruqkk9q
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=19ac89b2133c2463f59298fddc8584693c2e7ecb1fc435623eeb481c2253ccbd]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc.yandex_vpc_subnet.subnet: Importing from ID "e9bk6v5p1fvl1ruqkk9q"...
module.vpc.yandex_vpc_subnet.subnet: Import prepared!
  Prepared yandex_vpc_subnet for import
module.vpc.yandex_vpc_subnet.subnet: Refreshing state... [id=e9bk6v5p1fvl1ruqkk9q]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd8tckeqoshi403tks4l]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform state list
data.template_file.cloudinit
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]
module.vpc.yandex_vpc_network.vpc
module.vpc.yandex_vpc_subnet.subnet
bonanzza@bonanzza:~/Netology/devops-netology/terraform-04$ terraform plan
module.test-vm.data.yandex_compute_image.my_image: Reading...
data.template_file.cloudinit: Reading...
module.vpc.yandex_vpc_network.vpc: Refreshing state... [id=enpbbrvv847bna3b33hi]
data.template_file.cloudinit: Read complete after 0s [id=19ac89b2133c2463f59298fddc8584693c2e7ecb1fc435623eeb481c2253ccbd]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 0s [id=fd8tckeqoshi403tks4l]
module.vpc.yandex_vpc_subnet.subnet: Refreshing state... [id=e9bk6v5p1fvl1ruqkk9q]
module.test-vm.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmgvrei99k3bbjlv7gl]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

```



## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 


### Задание 4*

1. Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
  
Пример вызова:
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```

Предоставьте код, план выполнения, результат из консоли YC.

### Задание 5**

1. Напишите модуль для создания кластера managed БД Mysql в Yandex Cloud с 1 или 3 хостами в зависимости от переменной HA=true или HA=false. Используйте ресурс yandex_mdb_mysql_cluster (передайте имя кластера и id сети).
2. Напишите модуль для создания базы данных и пользователя в уже существующем кластере managed БД Mysql. Используйте ресурсы yandex_mdb_mysql_database и yandex_mdb_mysql_user (передайте имя базы данных, имя пользователя и id кластера при вызове модуля).
3. Используя оба модуля, создайте кластер example из одного хоста, а затем добавьте в него БД test и пользователя app. Затем измените переменную и превратите сингл хост в кластер из 2х серверов.
4. 
Предоставьте план выполнения и по-возможности результат. Сразу же удаляйте созданные ресурсы, так как кластер может стоить очень дорого! Используйте минимальную конфигурацию.

### Задание 6***  

1. Разверните у себя локально vault, используя docker-compose.yml в проекте.
2. Для входа в web интерфейс и авторизации terraform в vault используйте токен "education"
3. Создайте новый секрет по пути http://127.0.0.1:8200/ui/vault/secrets/secret/create  
Path: example  
secret data key: test 
secret data value: congrats!  
4. Считайте данный секрет с помощью terraform и выведите его в output по примеру:
```
provider "vault" {
 address = "http://<IP_ADDRESS>:<PORT_NUMBER>"
 skip_tls_verify = true
 token = "education"
}
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}
output "vault_example" {
 value = "${data.vault_generic_secret.vault_example.data["value"]}"
}
```
5. Попробуйте разобраться в документации и записать новый секрет в vault с помощью terraform. 


### Правила приема работы

В своём git-репозитории создайте новую ветку terraform-04, закомитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-04.

В качестве результата прикрепите ссылку на ветку terraform-04 в вашем репозитории.

ВАЖНО!Удалите все созданные ресурсы.

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 
