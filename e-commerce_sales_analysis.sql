select * from sales;


-- 1. Which categories generate the highest profit margins?
select category,sum(net_price) as revenue,sum(profit) as profit,
round(100 * sum(profit)/nullif(sum(net_price),0),2) as margin
from sales group by category order by margin desc;


-- 2. Which sub-categories are most and least profitable?
select sub_category,sum(net_price) as revenue,sum(profit) as profit,
round(100 * sum(profit)/nullif(sum(net_price),0),2) as margin
from sales group by sub_category order by margin desc;


-- 3. What are the top 5 cities by total profit?
select city,sum(profit) as total_profit from sales
group by city order by total_profit desc limit 5;


-- 4. What are the top 10 most expensive products?
select category,product_name,net_price,
dense_rank() over(order by net_price desc) as price_order from sales
limit 10;


-- 5. How do discount strategies impact category profitability?
select category,round(avg(discount),1) as avg_discount_pct,
round(avg(discount_amt),2) as avg_discount_amt,
round(100*sum(profit)/nullif(sum(net_price),0),2) as margin from sales
group by category order by margin;


-- 6. Which categories sell the most units?
select category,total_sold,
dense_rank() over(order by total_sold desc) as sales_rank
from (
select category,count(*) as total_sold from sales
group by category
) t order by sales_rank;


-- 7. Which categories have the highest average profit per sale?
select category,avg_profit,
dense_rank() over(order by avg_profit desc) as profit_rank
from (
select category,round(avg(profit),2) as avg_profit
from sales group by category
) order by profit_rank;


-- 8. Which payment modes are most frequently used?
select payment_mode,count(*) as total_payments from sales 
group by payment_mode order by total_payments desc;


-- 9. How does revenue by payment mode change over time?
select 
date_trunc('month',order_date) as month,
payment_mode,sum(net_price) as revenue
from sales group by month, payment_mode
order by month desc;


-- 10. Which cities generate the highest profit per order?
select city,count(order_id) as orders, sum(net_price) as revenue,
sum(profit) as profit, round(sum(profit)/count(order_id),2) as profit_per_order from sales
group by city order by profit_per_order desc;


-- 11. Which categories are most profitable in the last 6 months?
select category,sum(net_price) as revenue,
sum(profit) as total_profit from sales
where order_date >= current_date - interval '6 months'
group by category order by total_profit desc;


-- 12. Are repeat customers more profitable than one-time customers?
select 
case when cnt > 1 then 'Repeat'
else 'One Time'
end as customer_type,
count(*) as customers, round(avg(profit),2) as avg_profit_per_customer
from(
select customer_name, count(*) as cnt, sum(profit) as profit from sales
group by customer_name) t group by customer_type;


-- 13. How does order value segmentation impact profitability?
select 
case when net_price < 3000 then 'Low'
when net_price between 3000 and 10000 then 'Medium'
else 'High' end as price_segment,
count(*) as orders, round(avg(profit),2) as avg_profit,
sum(profit) as total_profit
from sales group by price_segment;
