#Конструкция в поиске
with my_data as (
    select null as col
    union all
    select 'null'
)
select
     col
    ,col = null as c1
    ,col = 'null' as c2
    ,col != null as c3
    ,col != 'null' as c4
    ,col is null as c5
    ,col is not null as c6
    
    ,col is distinct from null as c7
    ,col is distinct from 'null' as c8
    ,col is not distinct from null as c9
    ,col is not distinct from 'null' as c10
    from my_data

#фильтрация оконной функции прямо в запросе
select order_id, order_state
from orders
qualify row_number() over (partition by order_id order by ordered_at desc) = 1


#Удаление и сохранение в таблице только последних записей

MERGE INTO Orders AS target
USING (
    SELECT order_no, MAX(updated_at) AS max_ts
    FROM Orders
    GROUP BY order_no
) AS source
ON target.order_no = source.order_no AND target.updated_at = source.max_ts
WHEN NOT MATCHED BY SOURCE THEN
    DELETE


#Загрузка данных из файла

COPY raw.sales
FROM '/var/lib/postgresql/big_sales.csv'   -- путь до файла на сервере или локальный путь(если постгре локальная).
WITH (
    FORMAT      csv,       -- CSV-парсер
    HEADER      true,      -- пропускаем строку заголовков
    DELIMITER   ',',       -- если вдруг не запятая
    QUOTE       '"',       -- кавычки по умолчанию
    ENCODING    'UTF8'     -- кодировка можно изменить если будет "криво"
);

#выдача только последнего заказа
select distinct on (order_id) * 
from orders 
order by order, created_at desc 


#Выдача кол-во артикулов с гаммой А, B
select count(*) filter (where gamma = 'A') as count_A
, count(*) filter (where gamma = 'B') as count_B
from bdd_rms


#Генерация дат по таблице
SELECT generate_series(
        (SELECT MIN(sale_date) FROM Sales)::date,
        (SELECT MAX(sale_date) FROM Sales)::date,
        '1 day'
    ) AS dt


# Добавление строк без дубликатов
INSERT INTO Currencies (code, name, updated_at)
VALUES
    ('USD', 'US Dollar',      NOW()),
    ('JPY', 'Japanese Yen',   NOW()),
    ('EUR', 'Euro (fixed)',   NOW())
ON CONFLICT (code) DO UPDATE
    SET name       = EXCLUDED.name,
        updated_at = EXCLUDED.updated_at;



