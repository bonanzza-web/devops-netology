1. vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep '/tmp'
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7fffcfacd550 /* 23 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")
Как я понял ответ chdir("/tmp")
------------------------------------------------------------------------------------
2. vagrant@vagrant:~$ strace file 2>&1 | grep openat
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
Ответ: openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
-------------------------------------------------------------------------------------
3. Воспользовался примером из вебинара
 vagrant@vagrant:~$ tail -f test_file &
[1] 1676
vagrant@vagrant:~$ ps -p 1676
    PID TTY          TIME CMD
   1676 pts/0    00:00:00 tail
vagrant@vagrant:~$ rm test_file
vagrant@vagrant:~$ ps -p 1676
    PID TTY          TIME CMD
   1676 pts/0    00:00:00 tail
vagrant@vagrant:~$ lsof | grep delete
tail      1676                       vagrant    3r      REG              253,0        0    1311537 /home/vagrant/test_file (deleted)
vagrant@vagrant:~$ ls -l /proc/1676/fd
total 0
lrwx------ 1 vagrant vagrant 64 Oct 22 11:37 0 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Oct 22 11:37 1 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Oct 22 11:37 2 -> /dev/pts/0
lr-x------ 1 vagrant vagrant 64 Oct 22 11:37 3 -> '/home/vagrant/test_file (deleted)'
lr-x------ 1 vagrant vagrant 64 Oct 22 11:37 4 -> anon_inode:inotify
vagrant@vagrant:~$ echo "anything" > /proc/1676/fd/3
anything
Файл обновляется. Для уничтожения процесса можно воспользоваться kill PID
---------------------------------------------------------------------------------------
4. Зомби не занимают память, но занимают место в записях таблицы процессов
--------------------------------------------------------------------------------------
5. vagrant@vagrant:~$ dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
vagrant@vagrant:~$ /usr/sbin/opensnoop-bpfcc
could not open bpf map: events, error: Operation not permitted
Traceback (most recent call last):
  File "/usr/sbin/opensnoop-bpfcc", line 180, in <module>
    b = BPF(text=bpf_text)
  File "/usr/lib/python3/dist-packages/bcc/__init__.py", line 347, in __init__
    raise Exception("Failed to compile BPF module %s" % (src_file or "<text>"))
Exception: Failed to compile BPF module <text>
vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
889    vminfo              5   0 /var/run/utmp
649    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
649    dbus-daemon        21   0 /usr/share/dbus-1/system-services
649    dbus-daemon        -1   2 /lib/dbus-1/system-services
649    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/
1      systemd            12   0 /proc/660/cgroup
----------------------------------------------------------------------------------------
6. vagrant@vagrant:~$ strace uname -i

 uname({sysname="Linux", nodename="vagrant", ...}) = 0
Не могу найти цитату, прошу подсказать как искать, в man uname ничего не нашел
----------------------------------------------------------------------------------------
7. && - это логический оператор И, поэтому если написать две команды через && то вторая выполнится только при условии выполнения первой
; - это разделитель команд, вторая выполнится в независимости от выполнения первой
set — это встроенная команда оболочки, которая позволяет отображать или устанавливать переменные оболочки и среды, параметр -e указывает оболочке выйти, если команда дает ненулевой статус выхода. 
Проще говоря, оболочка завершает работу при сбое команды.
Использовать set -e вместе с && нет смысла.
------------------------------------------------------------------------------------------
8. -e предписывает bash немедленно завершить работу, если какая-либо команда имеет ненулевой статус завершения.
-u рассматривает неустановленные переменные как ошибку при замене.
-x печатает команды и их аргументы по мере их выполнения.
-o pipefail возвращает значение конвейера - это статус
последней команыа для завершения с ненулевым статусом,
или ноль, если ни одна команда не завершилась с ненулевым статусом 
---------------------------------------------------------------------------------------------
9. vagrant@vagrant:~$ ps -o stat
STAT
Ss
R+
