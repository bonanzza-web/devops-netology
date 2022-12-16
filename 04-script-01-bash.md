1 Задание
a=1
b=2
c=a+b  		результат будет "a+b" т.к. переменной была присвоена строка
d=$a+$b		результат будет "1+2" т.к. переменной присвоена строка со значениями переменных a и b
e=$(($a+$b))	результат будет "3" т.к. переменной присвоено значение операции сложения переменных a и b

2 Задание
while ((1==1))
do
	curl http://192.168.0.9
	if (($? != 0))
	then
		date > curl.log
	else echo "Connection restored" > curl.log;break
	fi
done
В первой строке была ошибка пропущена вторая скобка. Хост поменял на свой, установил апач для теста.
В строке date >> curl.log убрал один значок, чтобы файл не переполнялся. Добавил условие else echo "Connection restored" > curl.log;break
для завершения цикла и перезаписи curl.log

3 Задание
#!/usr/bin/env bash
declare -i attempts
attempts=0
hosts=(192.168.0.9:80 173.194.222.113:80 87.250.250.242:80)
while (($attempts<5))
do
        for i in ${hosts[@]}
        do
        curl http://$i > /dev/null
                if (($? == 0))
                then
                echo "Host $i:80 available" >> hosts-log
                fi
        done
        attempts=$(($attempts+1))
done

4 Задание
#!/usr/bin/env bash
hosts=(192.168.0.20:80 173.194.222.113:80 87.250.250.242:80)
while ((1 == 1))
do
        for i in ${hosts[@]}
        do
        curl --connect-timeout 3 http://$i > /dev/null
                if (($? != 0))
                then
                echo "Host $i:80 unavailable" >> error
                break
                fi
        done
done
