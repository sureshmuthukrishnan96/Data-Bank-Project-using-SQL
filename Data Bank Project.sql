create database case3;
use case3;

##Q1
select count(distinct node_id)
as unique_nodes
from customer_nodes;

select region_id,count(node_id) as node_count 
from customer_nodes
inner join regions
using(region_id)
group by region_id;



SELECT region_name, SUM(txn_amount) AS total_transactions
FROM regions,customer_nodes,customer_transactions
where regions.region_id=customer_nodes.region_id and 
customer_nodes.customer_id=customer_transactions.customer_id
group by region_name;

select round(avg(datediff(end_date,start_date)),2)
as avg_days from customer_nodes
where end_date!='9999-12-31';
select txn_type,count(*)as unique_count,
sum(txn_amount) as total_amount
from customer_transactions
group by txn_type;

select round(count(customer_id)/(select count(distinct customer_id)
from customer_transactions)) as average_deposit_amount 
from customer_transactions
where txn_type='deposit'; 

with transaction_count_per_month_cte as
(select customer_id,month(txn_date) as txn_month,
sum(if(txn_type='deposit',1,0)) as deposit_count,
sum(if(txn_type='withdrawal',1,0)) as withdrawal_count,
sum(if(txn_type='purchase',1,0)) as purchase_count
from customer_transactions
group by customer_id,month(txn_date))

select txn_month,count(distinct customer_id)as customer_count
from tansaction_count_per_month_cte
where deposit_count>1 and 
purchase_count=1 or withdrawal_count=1
group by txn_month;

WITH transaction_count_per_month_cte AS
  (SELECT customer_id,
          month(txn_date) AS txn_month,
          SUM(IF(txn_type="deposit", 1, 0)) AS deposit_count,
          SUM(IF(txn_type="withdrawal", 1, 0)) AS withdrawal_count,
          SUM(IF(txn_type="purchase", 1, 0)) AS purchase_count
   FROM customer_transactions
   GROUP BY customer_id,
            month(txn_date))
SELECT txn_month,
       count(DISTINCT customer_id) as customer_count
FROM transaction_count_per_month_cte
WHERE deposit_count>1
  AND (purchase_count = 1
       OR withdrawal_count = 1)
GROUP BY txn_month;