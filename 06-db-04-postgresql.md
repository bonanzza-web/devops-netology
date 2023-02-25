#Задача 1  
Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.  
Подключитесь к БД PostgreSQL используя psql.  
Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.  
Найдите и приведите управляющие команды для:  
•	вывода списка БД  
•	подключения к БД  
•	вывода списка таблиц  
•	вывода описания содержимого таблиц  
•	выхода из psql  
Ответ:  
  
1.	\l[+]   [PATTERN]      list databases  
2.	\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}  connect to new database (currently "new_db")  
3.	\dt[S+] [PATTERN]    list tables  
4.	\d[S+]    list tables, views, and sequences  
5.	\q   quit psql  
  
#Задача 2  
Используя psql создайте БД test_database.  
Изучите бэкап БД.  
Восстановите бэкап БД в test_database.  
Перейдите в управляющую консоль psql внутри контейнера.  
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.  
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.  
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.  
Ответ:  
  
root@f3691f6761b1:/# createdb test_database -U admin  
root@f3691f6761b1:/# psql -f /var/lib/postgresql/backup/test_dump.sql test_database -U admin  
SET  
SET  
SET  
SET  
SET  
 set_config  
"------------"  
  
(1 row)  
  
SET  
SET  
SET  
SET  
SET  
SET  
CREATE TABLE  
ALTER TABLE  
CREATE SEQUENCE  
ALTER TABLE  
ALTER SEQUENCE  
ALTER TABLE  
COPY 8  
 setval  
"--------"  
      8  
(1 row)  
  
ALTER TABLE  
root@f3691f6761b1:/# psql -d test_database -U admin  
psql (13.10 (Debian 13.10-1.pgdg110+1))  
Type "help" for help.  
  
test_database=# analyze verbose orders;  
INFO:  analyzing "public.orders"  
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows  
ANALYZE  
test_database=# select avg_width from pg_stats where tablename='orders';  
 avg_width  
"-----------"  
         4  
        16  
         4  
(3 rows)  
  
#Задача 3  
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
Предложите SQL-транзакцию для проведения данной операции.
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?  
test_database=# \dt+  
                              List of relations  
 Schema |  Name  | Type  |  Owner   | Persistence |    Size    | Description  
--------+--------+-------+----------+-------------+------------+-------------  
 public | orders | table | postgres | permanent   | 8192 bytes |  
(1 row)  
  
test_database=# begin;  
BEGIN  
test_database=*# create table orders_part (id integer, title varchar(100), price integer) partition by range(price);  
CREATE TABLE  
test_database=*# create table orders_1 partition of orders_part for values from (0) to (499);  
CREATE TABLE  
test_database=*# create table orders_2 partition of orders_part for values from (499) to (1000);  
CREATE TABLE  
test_database=*# insert into orders_part(id, title, price) select * from orders;  
INSERT 0 8  
test_database=*# commit;  
COMMIT  
test_database=# \dt+  
                                      List of relations  
 Schema |    Name     |       Type        |  Owner   | Persistence |    Size    | Description  
--------+-------------+-------------------+----------+-------------+------------+-------------   
 public | orders      | table             | postgres | permanent   | 8192 bytes |  
 public | orders_1    | table             | admin    | permanent   | 8192 bytes |  
 public | orders_2    | table             | admin    | permanent   | 8192 bytes |  
 public | orders_part | partitioned table | admin    | permanent   | 0 bytes    |  
(4 rows)  
  
Можно было при создании таблицы воспользоваться партиционированием (метод разделения больших таблиц на много маленьких)  
  
#Задача 4  
Используя утилиту pg_dump создайте бекап БД test_database.  
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?  
root@f3691f6761b1:/# pg_dump -d test_database -U admin > /var/lib/postgresql/backup/new_dump.sql  
root@f3691f6761b1:/# ls /var/lib/postgresql/backup/  
new_dump.sql  test_dump.sql  
Чтобы добавить уникальность значению столбца title можно воспользоваться индексами.  
