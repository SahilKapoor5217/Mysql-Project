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
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then orders else 0 end) as yday_orders,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end) as yday_gmv,
round((sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end)/1.18),0) as yday_revenue,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then customers else 0 end) as yday_customers,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then new_customers else 0 end) as yday_new_customers,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then Yday_Live_Prducts else 0 end) as yday_liveproducts,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then Yday_Live_Stores else 0 end) as yday_livestores

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
count(distinct y.product_id) as Yday_Live_Prducts,
count(distinct a.store_id) as Yday_Live_Stores
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



