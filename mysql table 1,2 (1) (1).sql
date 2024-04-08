use join_class_m_btch;
show tables;


select min(order_date) from order_details_v1;
select max(order_date) from order_details_v1;
select * from producthierarchy;
select * from store_cities;
select * from order_details_v1;


select 
x.category,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then orders else 0 end) as yday_orders,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end) as yday_gmv,
round((sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end)/1.18),0) as yday_revenue,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then customers else 0 end) as yday_customers,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then new_customers else 0 end) as yday_new_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then orders else 0 end) as mtd_orders,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then gmv else 0 end) as mtd_gmv,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then revenue else 0 end) as mtd_revenue,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then customers else 0 end) as mtd_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then new_customers else 0 end) as mtd_new_customers,

sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month) then orders else 0 end) as lmtd_orders,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month) then gmv else 0 end)  as lmtd_gmv,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then revenue else 0 end) as lmtd_revenue,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then customers else 0 end) as lmtd_customers,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then new_customers else 0 end) as lmtd_new_customers,

sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then orders else 0 end) as lm_orders,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then gmv else 0 end) as lm_gmv,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then revenue else 0 end) as lm_revenue,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31")then customers else 0 end) as lm_customers,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31")then new_customers else 0 end) as lm_new_customers

from
(select 
y.category,
x.product_id,
y.product as product_name,
a.city,
x.order_date,
count(distinct x.order_id) orders,
sum(x.selling_price) as gmv,
sum(x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct z.customer_id) as new_customers
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
group by 1,2,3,4,5
)x
group by 1;



-- -----
select 
product_id,
product_name,
category,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then orders else 0 end) as yday_orders,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end) as yday_gmv,
round((sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end)/1.18),0) as yday_revenue,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then customers else 0 end) as yday_customers,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then new_customers else 0 end) as yday_new_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then orders else 0 end) as mtd_orders,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then gmv else 0 end) as mtd_gmv,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then revenue else 0 end) as mtd_revenue,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then customers else 0 end) as mtd_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then new_customers else 0 end) as mtd_new_customers,

sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month) then orders else 0 end) as lmtd_orders,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month) then gmv else 0 end)  as lmtd_gmv,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then revenue else 0 end) as lmtd_revenue,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then customers else 0 end) as lmtd_customers,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then new_customers else 0 end) as lmtd_new_customers,

sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then orders else 0 end) as lm_orders,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then gmv else 0 end) as lm_gmv,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then revenue else 0 end) as lm_revenue,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31")then customers else 0 end) as lm_customers,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31")then new_customers else 0 end) as lm_new_customers

from
(select 
y.category,
x.product_id,
y.product as product_name,
x.order_date,
count(distinct x.order_id) orders,
sum(x.selling_price) as gmv,
sum(x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct z.customer_id) as new_customers
from order_details_v1 x
join producthierarchy y on x.product_id=y.product_id
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
group by 1,2,3,4
)x
group by 1,2,3;


-- ------
select 
city,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then orders else 0 end) as yday_orders,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end) as yday_gmv,
round((sum(case when x.order_date=date_add(current_date(), interval - 1 day) then gmv else 0 end)/1.18),0) as yday_revenue,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then customers else 0 end) as yday_customers,
sum(case when x.order_date=date_add(current_date(), interval - 1 day) then new_customers else 0 end) as yday_new_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then orders else 0 end) as mtd_orders,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then gmv else 0 end) as mtd_gmv,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then revenue else 0 end) as mtd_revenue,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then customers else 0 end) as mtd_customers,
sum(case when x.order_date between date_format(curdate(),"%y-%m-01" ) and (curdate()-interval 1 day) then new_customers else 0 end) as mtd_new_customers,

sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month) then orders else 0 end) as lmtd_orders,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month) then gmv else 0 end)  as lmtd_gmv,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then revenue else 0 end) as lmtd_revenue,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then customers else 0 end) as lmtd_customers,
sum(case when order_date between date_format(current_date()-interval 1 month,"%2023-%m-01") and date_add(date_add(current_date(), interval -1 day), interval -1 month)then new_customers else 0 end) as lmtd_new_customers,

sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then orders else 0 end) as lm_orders,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then gmv else 0 end) as lm_gmv,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31") then revenue else 0 end) as lm_revenue,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31")then customers else 0 end) as lm_customers,
sum(case when order_date between date_format(now() - interval 1 month, "%2023-%m-01") and date_format(now() - interval 1 month, "%2023-%m-31")then new_customers else 0 end) as lm_new_customers

from
(select 
y.category,
x.product_id,
y.product as product_name,
a.city,
x.order_date,
count(distinct x.order_id) orders,
sum(x.selling_price) as gmv,
sum(x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct z.customer_id) as new_customers
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
group by 1,2,3,4,5
)x
group by 1;
