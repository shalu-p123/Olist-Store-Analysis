# Olist Store Analysis

# KPI 1 - Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select
kpi1.day_end,
concat(round(kpi1.total_payment / (select sum(payment_value) from olist_order_payments_dataset) *100,2), '%') as Percentage_values
from (select o.day_end, sum(p.payment_value) as Total_payment
from olist_order_payments_dataset as p
join  (select distinct order_id,
case when weekday(order_purchase_timestamp) in (5,6) 
then "weekend" else "weekdays"
end as day_end
from olist_orders_dataset) as o
on o.order_id = p.order_id
group by o.day_end) as kpi1 ;

# KPI 2 - Total Number of Orders with review score 5 and payment type as credit card

select
review_score,
payment_type,count(distinct p.order_id) as Number_of_orders
from olist_order_payments_dataset p
join olist_order_reviews_dataset r on p.order_id = r.order_id
where r.review_score = 5
and p.payment_type = 'credit_card';

# KPI 3 - Average number of days taken for order_delivered_customer_date for pet_shop

select
product_category_name,
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp))) asAvg_delivery_days
from olist_orders_dataset o
join olist_order_items_dataset i on i.order_id = o.order_id
join olist_products_dataset p on p.product_id = i.product_id
where p.product_category_name = 'pet_shop'
and o.order_delivered_customer_date is not null;

# KPI 4 - Average price and payment values from customers of sao paulo city

select
round(avg(i.price)) as Avg_price,
round(avg(p.payment_value)) as Avg_payment
from olist_customers_dataset c
join olist_orders_dataset o on c.customer_id = o.customer_id
join olist_order_items_dataset i on o.order_id = i.order_id
join olist_order_payments_dataset p on o.order_id = p.order_id
where c.customer_city = "sao paulo";

# KPI 5 - Relationship between shipping days Vs review scores.

select
round(avg(datediff(order_delivered_customer_date , order_purchase_timestamp)),0) as AVG_shipping_days,Review_score
from olist_orders_dataset o
join olist_order_reviews_dataset r on o.order_id = r.order_id
where order_delivered_customer_date is not null
and order_purchase_timestamp is not null
group by review_score;