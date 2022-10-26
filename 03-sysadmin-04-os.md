1. Перезапуск демон vagrant@vagrant:/etc/systemd/system$ sudo systemctl daemon-reload
Запуск sudo systemctl start node_exporter
Запускаю ps vagrant@vagrant:/etc/systemd/system$ ps aux | grep node
vagrant     3391  0.1  0.6 724836 12196 ?        Ssl  15:00   0:00 /usr/local/bin/node_exporter
vagrant     3412  0.0  0.0   6300   724 pts/1    S+   15:00   0:00 grep --color=auto node
Добавил в автозагрузку sudo systemctl enable node_exporter
Проверил статус после перезагрузки sudo systemctl status node_exporter
Еще раз запускаю ps vagrant@vagrant:/usr/local/bin$ ps aux | grep node
vagrant     3391  0.0  0.6 724836 12196 ?        Ssl  15:00   0:00 /usr/local/bin/node_exporter
vagrant     3502  0.0  0.0   6300   720 pts/0    S+   15:09   0:00 grep --color=auto node

2. Их слишком много. Например:
node_memory_Active_bytes
node_memory_MemFree_bytes  
node_memory_MemTotal_bytes
node_cpu_guest_seconds_total
node_cpu_seconds_total
node_network_device_id
node_network_flags
node_network_info
node_disk_filesystem_info
node_disk_info

3. Все получилось, скриншот приложен

4. Да
vagrant@vagrant:~$ dmesg | grep virtual
[    0.014346] CPU MTRRs all blank - virtualized system.
[    0.434469] Booting paravirtualized kernel on KVM
[    8.598589] systemd[1]: Detected virtualization oracle.

5. vagrant@vagrant:~$ sudo cat /proc/sys/fs/nr_open
1048576
Это максимальное число открытых дескрипторов для ядра
Мягкие ограничения: vagrant@vagrant:~$ ulimit -Sn
1024
Жесткие ограничения: vagrant@vagrant:~$ ulimit -Hn
1048576
6. vagrant@vagrant:~$ sudo -i
root@vagrant:~# unshare -f --pid --mount-proc sleep 1h
^Z
[1]+  Stopped                 unshare -f --pid --mount-proc sleep 1h
root@vagrant:~# ps aux | grep sleep
root        1591  0.0  0.0   5480   580 pts/0    T    16:18   0:00 unshare -f --pid --mount-proc sleep 1h
root        1592  0.0  0.0   5476   516 pts/0    S    16:18   0:00 sleep 1h
root        1594  0.0  0.0   6432   656 pts/0    S+   16:19   0:00 grep --color=auto sleep
root@vagrant:~# ps
    PID TTY          TIME CMD
   1578 pts/0    00:00:00 sudo
   1580 pts/0    00:00:00 bash
   1591 pts/0    00:00:00 unshare
   1592 pts/0    00:00:00 sleep
   1633 pts/0    00:00:00 ps
root@vagrant:~# nsenter -t 1592 -p -m
root@vagrant:/# ps
    PID TTY          TIME CMD
      1 pts/0    00:00:00 sleep
      2 pts/0    00:00:00 bash
     13 pts/0    00:00:00 ps

7.  Команда :(){ :|:& };:

В действительности эта команда является логической бомбой. Она оперирует определением функции с именем ‘:‘, которая вызывает сама себя дважды: один раз на переднем плане и один раз в фоне. Она продолжает своё выполнение снова и снова, пока система не зависнет. 

Помог стабилизировать систему [  855.713441] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-5.scope

Можно изменить число процессов в /etc/security/limits.conf
