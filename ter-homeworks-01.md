# Домашнее задание к занятию "Введение в Terraform"

### Цель задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чеклист готовности к домашнему заданию

1. Скачайте и установите актуальную версию **terraform**(не менее 1.3.7). Приложите скриншот вывода команды ```terraform --version```
2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Установка и настройка Terraform  [ссылка](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#from-yc-mirror)
2. Зеркало документации Terraform  [ссылка](https://registry.tfpla.net/browse/providers) 
3. Установка docker [ссылка](https://docs.docker.com/engine/install/ubuntu/) 
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте.    

Ответ:    
  
    root@debian-docker:~/terraformdz/ter-homeworks/01/src# ls  
    main.tf  terraform  terraformrc  
    root@debian-docker:~/terraformdz/ter-homeworks/01/src# ./terraform init   
    
    Initializing the backend...  
  
    Initializing provider plugins...  
    - Finding kreuzwerker/docker versions matching "~> 3.0.1"...  
    - Finding latest version of hashicorp/random...  
    - Installing kreuzwerker/docker v3.0.1...  
    - Installed kreuzwerker/docker v3.0.1 (unauthenticated)  
    - Installing hashicorp/random v3.4.3...  
    - Installed hashicorp/random v3.4.3 (unauthenticated)  
  
    Terraform has created a lock file .terraform.lock.hcl to record the provider  
    selections it made above. Include this file in your version control repository  
    so that Terraform can guarantee to make the same selections by default when  
    you run "terraform init" in the future.  
      
    ╷   
    │ Warning: Incomplete lock file information for providers  
    │  
    │ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:  
    │   - hashicorp/random  
    │   - kreuzwerker/docker  
    │  
    │ The current .terraform.lock.hcl file only includes checksums for linux_386, so Terraform running on another platform will fail to install these providers.  
    │  
    │ To calculate additional checksums for another platform, run:  
    │   terraform providers lock -platform=linux_amd64  
    │ (where linux_amd64 is the platform to generate)  
    ╵
    
    Terraform has been successfully initialized!  
    
    You may now begin working with Terraform. Try running "terraform plan" to see  
    any changes that are required for your infrastructure. All Terraform commands  
    should now work.  
    
    If you ever set or change modules or backend configuration for Terraform,  
    rerun this command to reinitialize your working directory. If you forget, other  
    commands will detect it and remind you to do so if necessary.  

2. Изучите файл **.gitignore**. В каком terraform файле допустимо сохранить личную, секретную информацию?

Ответ:  
Ни в каком, в гит файлах запрещено хранить ключи и пароли  
3. Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**. Пришлите его в качестве ответа.

Ответ:  
    "result": "gsSv73j5VoHK3ZJv",  
4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**. Выполните команду ```terraform -validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.

Ответ:  

На 24 строке не указано имя создаваемого ресурса. Указал “nginx”  
На 29 строке ошибка в имени 1nginx, удалил 1  

5. Выполните код. В качестве ответа приложите вывод команды ```docker ps```  

Ответ:  

    root@debian-docker:~/terraformdz/ter-homeworks/01/src# docker ps
    CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS          PORTS                                       NAMES
    6739e22c9ab2   904b8cb13b93   "/docker-entrypoint.…"   8 seconds ago   Up 5 seconds    0.0.0.0:8000->80/tcp                        example_gsSv73j5VoHK3ZJv
    f3691f6761b1   postgres:13    "docker-entrypoint.s…"   2 weeks ago     Up 34 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres

6. Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```. Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ? 

Ответ:  

    root@debian-docker:~/terraformdz/ter-homeworks/01/src# grep -i -n "example_gsSv73j5VoHK3ZJv" ./*  
    ./terraform.tfstate:59:            "name": "example_gsSv73j5VoHK3ZJv",  
    root@debian-docker:~/terraformdz/ter-homeworks/01/src# sed -i 's/example_gsSv73j5VoHK3ZJv/hello_world/' terraform.tfstate  
    
Также заменил name в main.tf, чтобы имя контейнера поменялось на hello_world:
    root@debian-docker:~/terraformdz/ter-homeworks/01/src# docker ps  
    CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                       NAMES  
    a3911a1c3962   904b8cb13b93   "/docker-entrypoint.…"   11 seconds ago   Up 10 seconds   0.0.0.0:8000->80/tcp                        hello_world  
    f3691f6761b1   postgres:13    "docker-entrypoint.s…"   2 weeks ago      Up 48 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres  
    
Как я понял, ключом –auto-approve можно удалить группу машин или настроек, поэтому нужно все перепроверить перед его использованием  


7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.  

Ответ:  

    root@debian-docker:~/terraformdz/ter-homeworks/01/src# docker ps  
    CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS          PORTS                                       NAMES  
    f3691f6761b1   postgres:13   "docker-entrypoint.s…"   2 weeks ago   Up 52 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres  
    root@debian-docker:~/terraformdz/ter-homeworks/01/src# less terraform.tfstate  
    {  
      "version": 4,  
      "terraform_version": "1.3.7",  
      "serial": 13,  
      "lineage": "eca8e0a5-52e5-cb9a-9f06-da8179b8af0e",  
      "outputs": {},  
      "resources": [],  
      "check_results": null  
    }  

8. Объясните, почему при этом не был удален docker образ **nginx:latest** ?(Ответ найдите в коде проекта или документации)  

Ответ:  

В файле main.tf указан параметр keep_locally = true, что позволяет сохранить образ ресурса после применения terraform destroy  


------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 2*

1. Изучите в документации provider [**Virtualbox**](https://registry.tfpla.net/providers/shekeriev/virtualbox/latest/docs/overview/index) от 
shekeriev.
2. Создайте с его помощью любую виртуальную машину.

В качестве ответа приложите plan для создаваемого ресурса.

------

### Правила приема работы

Домашняя работа оформляется в отдельном GitHub репозитории в файле README.md.   
Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 
