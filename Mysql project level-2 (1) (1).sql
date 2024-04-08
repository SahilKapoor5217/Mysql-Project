use join_class_m_btch;
show tables;


select min(order_date) from order_details_v1;
select max(order_date) from order_details_v1;
select * from producthierarchy;
select * from store_cities;
select * from order_details_v1;


select 
x.category,
x.sub_category,
x.product_id,
x.product_name,
x.state,
x.city1,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then orders else 0 end) as mtd_orders,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then gmv else 0 end) as mtd_gmv,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then revenue else 0 end) as mtd_revenue,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then customers else 0 end) as mtd_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then new_customers else 0 end) as mtd_new_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then Live_Prducts else 0 end) as mtd_live_Products,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then Live_Stores else 0 end) as mtd_new_stores

from
(select 
y.category,
x.product_id,
y.product as product_name,
a.city,
x.order_date,
y.sub_category,
a.state as state,
a.city as city1,
count(distinct x.order_id) orders,
sum(x.selling_price) as gmv,
sum(x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct z.customer_id) as new_customers,
count(distinct y.product_id) as Live_Prducts,
count(distinct a.store_id) as Live_Stores
from order_details_v1 x
join producthierarchy y on x.product_id=y.product_id
join store_cities a on x.store_id=a.store_id 
left join

(select 
*
from 
(select 
order_id,
customer_id,
order_date,
rank() over (partition by customer_id order by order_date) as rn
from order_details_v1 x
join producthierarchy y on x.product_id=y.product_id
) x where rn=1
)z on x.order_id=z.order_id
group by 1,2,3,4,5,6,7,8
)x
group by 1,2,3,4,5,6;



