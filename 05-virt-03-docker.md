Задача 1.

https://hub.docker.com/repository/docker/bonanzza/devopsnginx/general

Содержимое Dockerfile:
FROM nginx
COPY ./index.html /usr/share/nginx/html/index.html

Запускаю build:
docker build -t bonanzza/devopsnginx

Создаю контейнер с образа, пробрасываю порт с 80 на 7777:
docker run -d --name devopsnginx -p 7777:80 bonanzza/devopsnginx



Задача 2.
1) Высоконагруженное монолитное java веб-приложение
Т.к. приложение высоконагруженное, оно требует большое количество ресурсов, следует использовать виртуальную или физическую машину
2) Nodejs веб-приложение
Подойдет контейнер, потому что скорей всего приложение легкое, быстро развернется в докере, и есть образ
3) Мобильное приложение c версиями для Android и iOS
Думаю что подойдет контейнер, т.к. врядли эти приложения потребуют огромное количество ресурсов.
4) Шина данных на базе Apache Kafka
Затрудняюсь ответить. Прочитал что можно испоьзовать контейнер
5) Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana
Так же, как в предыдущем вопросе много незнакомых слов. Прочитал, что Elasticsearch требует много оперативной памяти, поэтому считаю,   что в этом случае нужен физический сервер
6) Мониторинг-стек на базе Prometheus и Grafana
У знакомых айтишников Zabbix стоит на тонком клиенте, поэтому соглашусь с ними и выберу отдельную физическую машинку
7) MongoDB, как основное хранилище данных для java-приложения
Можно использовать контейнер, цитата из интернета "Запуск MongoDB в Docker обеспечивает изоляцию и переносимость вашей базы данных.   Вы можете быстро запускать новые экземпляры, не устанавливая сервер Mongo вручную. Контейнеры ваших приложений могут напрямую связываться с Mongo через общую сеть Docker."
8) Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
Подойдет контейнер, т.к. для реализации CI/CD процессов важна скорость развертывания.



Задача 3.
#Создаю контейнер с centos:
root@debian-docker:~# docker run -it --name cent -v $HOME/data:$HOME/data centos
[root@2fb00dd9b8a3 /]# ls
bin  etc   lib    lost+found  mnt  proc  run   srv  tmp  var
dev  home  lib64  media       opt  root  sbin  sys  usr


#Создаю контейнер с debian:
root@debian-docker:~# docker run -it --name deb -v $HOME/data:$HOME/data debian
root@69300055a4dc:/# cd ~
root@69300055a4dc:~# ls
data


#Создаю файл в папке data на centos:
[root@2fb00dd9b8a3 data]# echo "Hello Netology" > testfile
[root@2fb00dd9b8a3 data]# ls
testfile


#Создаю файл в папке data на хостовой машине:
root@debian-docker:~/data# echo "Hello world" > testfile.host
root@debian-docker:~/data# ls
testfile  testfile.host

#Проверяю листинг в контейнере debian:
root@69300055a4dc:~# ls -l data
total 8
-rw-r--r-- 1 root root 15 Jan 21 16:00 testfile
-rw-r--r-- 1 root root 12 Jan 21 16:02 testfile.host

Вывод: папки синхронизируются
