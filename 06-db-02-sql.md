Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

version: '3.1'

volumes:
  postgres_data:
  postgres_backup:


services:
  postgres:
    image: postgres:12
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - postgres_backup:/var/lib/postgresql/backup
    container_name: postgres
    restart: always
    environment:
      POSTGRES_USER: test-admin-user
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: test_db
    ports:
      - 5432:5432
root@debian-docker:~# docker volume list
DRIVER    VOLUME NAME
local     6b4613ed8e4c0bd5b7cb8c3f3a5973a0b0692e63ff367d1b5c92ea190d5d07f5
local     postgres-compose_postgres_backup
local     postgres-compose_postgres_data


Задача 2

В БД из задачи 1:

    создайте пользователя test-admin-user и БД test_db
    в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
    предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
    создайте пользователя test-simple-user
    предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

    id (serial primary key)
    наименование (string)
    цена (integer)

Таблица clients:

    id (serial primary key)
    фамилия (string)
    страна проживания (string, index)
    заказ (foreign key orders)

Приведите:

    итоговый список БД после выполнения пунктов выше,
    описание таблиц (describe)
    SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
    список пользователей с правами над таблицами test_db
    
Ответы:
Пользователь test-admin-user и бд test_db были созданы в манифесте.
Создаю таблицы:
root@d74b086ec46d:/# psql -U test-admin-user -d test_db
psql (12.14 (Debian 12.14-1.pgdg110+1))
Type "help" for help.

test_db=# create table orders (id serial primary key, name varchar(30), price integer);
CREATE TABLE
test_db=# create table clients (id serial primary key, lastname varchar(50), country varchar(50), orderid integer references orders);
CREATE TABLE
test_db=# create index country_ind on clients(country);
CREATE INDEX
Даю привелегии:
test_db=# grant all on all tables in schema public to "test-admin-user";
GRANT
Создаю нового пользователя и даю привилегии:
test_db=# create user "test-simple-user";
CREATE ROLE
test_db=# grant select, insert, update, delete on all tables in schema public to "test-simple-user";
GRANT

Список баз данных:
test_db=# \l
                                             List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges
-----------+-----------------+----------+------------+------------+-----------------------------------------
 postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
Список таблиц с описанием:
test_db=# \dt+
                         List of relations
 Schema |  Name   | Type  |      Owner      |  Size   | Description
--------+---------+-------+-----------------+---------+-------------
 public | clients | table | test-admin-user | 0 bytes |
 public | orders  | table | test-admin-user | 0 bytes |
(2 rows)

SQL-запрос для выдачи списка пользователей с правами над таблицами test_db:
test_db=# select * from information_schema.table_privileges where table_name='orders';
     grantor     |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
-----------------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 test-admin-user | test-admin-user  | test_db       | public       | orders     | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | public       | orders     | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | orders     | TRIGGER        | YES          | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 test-admin-user | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
(11 rows)
test_db=# select * from information_schema.table_privileges where table_name='clients';
     grantor     |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
-----------------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 test-admin-user | test-admin-user  | test_db       | public       | clients    | INSERT         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | SELECT         | YES          | YES
 test-admin-user | test-admin-user  | test_db       | public       | clients    | UPDATE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | DELETE         | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user  | test_db       | public       | clients    | TRIGGER        | YES          | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 test-admin-user | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(11 rows)
Список пользователей с правами над таблицами test_db:
test_db=# \dp
                                                Access privileges
 Schema |      Name      |   Type   |              Access privileges              | Column privileges | Policies
--------+----------------+----------+---------------------------------------------+-------------------+----------
 public | clients        | table    | "test-admin-user"=arwdDxt/"test-admin-user"+|                   |
        |                |          | "test-simple-user"=arwd/"test-admin-user"   |                   |
 public | clients_id_seq | sequence |                                             |                   |
 public | orders         | table    | "test-admin-user"=arwdDxt/"test-admin-user"+|                   |
        |                |          | "test-simple-user"=arwd/"test-admin-user"   |                   |
 public | orders_id_seq  | sequence |                                             |                   |
(4 rows)


Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders
Наименование 	цена
Шоколад 	10
Принтер 	3000
Книга 	500
Монитор 	7000
Гитара 	4000

Таблица clients
ФИО 	Страна проживания
Иванов Иван Иванович 	USA
Петров Петр Петрович 	Canada
Иоганн Себастьян Бах 	Japan
Ронни Джеймс Дио 	Russia
Ritchie Blackmore 	Russia

Используя SQL синтаксис:

    вычислите количество записей для каждой таблицы
    приведите в ответе:
        запросы
        результаты их выполнения.

Ответ:
test_db=# insert into orders values (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# insert into clients values(1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# select * from clients;
 id |       lastname       | country | orderid
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

test_db=# select count (*) from orders;
 count
-------
     5
(1 row)

test_db=# select count (*) from clients;
 count
-------
     5
(1 row)


Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:
ФИО 	Заказ
Иванов Иван Иванович 	Книга
Петров Петр Петрович 	Монитор
Иоганн Себастьян Бах 	Гитара

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказк - используйте директиву UPDATE.

Ответ:
test_db=# update clients set orderid=3 where lastname ='Иванов Иван Иванович';
UPDATE 1
test_db=# update clients set orderid=4 where lastname ='Петров Петр Петрович';
UPDATE 1
test_db=# update clients set orderid=5 where lastname ='Иоганн Себастьян Бах';
UPDATE 1
test_db=# select * from clients;
 id |       lastname       | country | orderid
----+----------------------+---------+---------
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
  1 | Иванов Иван Иванович | USA     |       3
  2 | Петров Петр Петрович | Canada  |       4
  3 | Иоганн Себастьян Бах | Japan   |       5
(5 rows)


Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

Ответ:
test_db=# explain select * from clients where orderid>0;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..13.75 rows=100 width=244)
   Filter: (orderid > 0)
(2 rows)
Explain показывает подробную информацию о запросе, стоимость выполнения запроса (cost)


Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

root@d74b086ec46d:/# pg_dump -U test-admin-user test_db > /var/lib/postgresql/backup/test_db_dump.sql
root@d74b086ec46d:/# ls /var/lib/postgresql/backup/
test_db_dump.sql
root@858e3fca38df:/# psql -f /var/lib/postgresql/backup/test_db_dump.sql -U test-admin-user
SET
SET
SET
SET
SET
 set_config
------------

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
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      1
(1 row)

 setval
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
GRANT
GRANT
