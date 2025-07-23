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
