Задача 1

Дайте письменые ответы на следующие вопросы:

    В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

    Ответ: Различие между режимами replication и global заключается в том, что режим replication обеспечивает избыточность, гарантируя выполнение определенного количества реплик служб, в то время как global обеспечивает распределение, запуская службу на каждом узле в кластере Swarm
   
    Какой алгоритм выбора лидера используется в Docker Swarm кластере?

    Ответ: Алгоритм выбора лидера, используемый в кластере Docker Swarm, - это алгоритм консенсуса Raft. Это широко используемый, надежный и отказоустойчивый алгоритм консенсуса, разработанный для распределенных систем. Он используется для поддержания согласованного состояния на всех узлах кластера и для обеспечения того, чтобы только один узел выступал в качестве ведущего в любой момент времени.

    Что такое Overlay Network?

    Ответ: Это виртуальная сеть, построенная поверх существующей физической сетевой инфраструктуры. позволяет контейнерам взаимодействовать друг с другом, как если бы они находились на одном физическом хосте, даже если они могут быть физически расположены на разных хостах в кластере.


Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker node ls

Ответ: 
    
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
lw8nxmii5uablqzplt0i972f3 *   node01.netology.yc   Ready     Active         Leader           23.0.1
1g2j45b8nhydzoqet2lde3tw5     node02.netology.yc   Ready     Active         Reachable        23.0.1
w5uurz9qr1x68vterl4j328ns     node03.netology.yc   Ready     Active         Reachable        23.0.1
otov4zmtgfqwy2hzv629mhc60     node04.netology.yc   Ready     Active                          23.0.1
ovpdmqwgh09z57m245qbngai4     node05.netology.yc   Ready     Active                          23.0.1
9i26aifqmjv79wd5phknlse5t     node06.netology.yc   Ready     Active                          23.0.1

Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker service ls

Ответ:

[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
yvbp9qzs6lap   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
mng9whd4uv0t   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
w72z5f6stlr8   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
odyzmn6i0xvk   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
swawendvgvph   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
k26om2wml7u6   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
cb563uhy4fbi   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
drvawcvb74jg   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0

