1. vagrant@vagrant:~/devops-netology$ type cd
cd is a shell builtin
Команда cd является встроенной. Команда используется только для перемещения по каталогам в терминале, поэтому, как я
понимаю, нет смысла делать ее внешней, хотя и возможно.

2. Альтернатива команде grep <some_string> <some_file> | wc -l будет grep -c <some_string> <some_file>
vagrant@vagrant:~/devops-netology$ grep line README.md | wc -l
3
vagrant@vagrant:~/devops-netology$ grep line README.md
New line
It is second line of my homework
It is third line of my homework
vagrant@vagrant:~/devops-netology$ grep -c line README
grep: README: No such file or directory
vagrant@vagrant:~/devops-netology$ grep -c line README.md
3

3. vagrant@vagrant:~/devops-netology$ lsof | grep systemd
systemd      1                           root  cwd   unknown
Процесс с PID 1 будет systemd
4. vagrant@vagrant:~/devops-netology$ tty
/dev/pts/0
vagrant@vagrant:~/devops-netology$ ls
03-sysadmin-02-terminal.md  branching  has_been_moved.txt  README.md  Teacher_readme.txt  terraform
vagrant@vagrant:~/devops-netology$ ls -l root 2>/dev/pts/1

vagrant@vagrant:~$ tty
/dev/pts/1
vagrant@vagrant:~$ ls: cannot access 'root': No such file or directory
ls
5. vagrant@vagrant:~$ cat ls.txt
ls.txt
tmp
cd is a shell builtin
ls: cannot access 'temp': No such file or directory
ls: cannot access 'temp': No such file or directory
vagrant@vagrant:~$ cat < ls.txt > stdout.txt
vagrant@vagrant:~$ cat stdout.txt
ls.txt
tmp
cd is a shell builtin
ls: cannot access 'temp': No such file or directory
ls: cannot access 'temp': No such file or directory

6. Не получается:
vagrant@vagrant:~$ ls -l root 2> /dev/tty1
bash: /dev/tty1: Permission denied
----------------------------------
Правка 6го задания:
vagrant@vagrant:~$ sudo ls -l /root 2> /dev/tty1
-bash: /dev/tty1: Permission denied
vagrant@vagrant:~$ ls -l /root 2> /dev/pts/1
vagrant@vagrant:~$

vagrant@vagrant:~$ tty
/dev/pts/1
vagrant@vagrant:~$ ls: cannot open directory '/root': Permission denied

Ответ: Не получилось перенаправления на /dev/tty даже с sudo, но получилось на /dev/pts/1. Может у меня что то не правильно настроено

7. vagrant@vagrant:~$ bash 5>&1
vagrant@vagrant:~$ echo Netology > /proc/$$/fd/5
Netology
bash 5>&1 создает дескриптор 5 и перенаправляет его в stdout, echo выводит этот дескриптор

8. vagrant@vagrant:~$ ls % 5>&2 2>&1 1>&5 |grep -c 'cannot access'
1

9.cat /proc/$$/environ выведет переменные среды, также переменные среды выводит команда env

10. /proc/<PID>/cmdline содержит командную строку процесса по PID
/proc/<PID>/exe содержит ссылку до файла процесса PID

11. vagrant@vagrant:~$ cat /proc/cpuinfo | grep sse
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht >sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase>flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht >sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase>Ответ SSE4_2

12. По умолчанию, когда вы запускаете команду на удаленном компьютере с помощью ssh, TTY не выделяется для удаленного с>Изменить поведение можно флагом -t.

13. Не очень понял вопрос, установил reptyr, ввел команду, получилось так:
vagrant@vagrant:~$ reptyr -l -s 3 702
Opened a new pty: /dev/pts/3
---------------------------------
vagrant@vagrant:~$ tty
/dev/pts/1
vagrant@vagrant:~$ ps -a
    PID TTY          TIME CMD
   1575 pts/1    00:00:00 ps
vagrant@vagrant:~$ sudo reptyr -T 1575
[-] Unable to open /proc/1575/stat: No such file or directory
Unable to attach to pid 1575: Operation not permitted
Ответ: Я не знаю почему, но не получается, 1 на 0 в указанных файлах менял, ничего, прошу объяснить что мне нужно сделать, чтобы все заработало

14. tee используется для разделения выводимых программой данных, таким образом данные могут быть использованы для вывод>(взято с википедии) Команда sudo tee будет иметь права на запись, так как запущена от рута


