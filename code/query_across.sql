-- across.sql - Querying across data sources.

-- First we look at the customer data from the MapR-DB.
use maprdb;

select cast(row_key as int) as cust_id, cast(t.personal.name as varchar(20)) as name,
cast(t.personal.gender as varchar(10)) as gender, cast(t.personal.age as varchar(10)) as age,
cast(t.address.state as varchar(4)) as state, cast(t.loyalty.agg_rev as dec(7,2)) as agg_rev,
cast(t.loyalty.membership as varchar(20)) as membership
from customers t limit 5;

-- There is now a customer ID.

use dfs.views;

-- Create a view called "custview".
create or replace view custview as select cast(row_key as int) as cust_id,
cast(t.personal.name as varchar(20)) as name, 
cast(t.personal.gender as varchar(10)) as gender, 
cast(t.personal.age as varchar(10)) as age, 
cast(t.address.state as varchar(4)) as state,
cast(t.loyalty.agg_rev as dec(7,2)) as agg_rev,
cast(t.loyalty.membership as varchar(20)) as membership
from maprdb.customers t;

-- Get total sales for each membership type.
select membership, sum(order_total) as sales from hive.orders, custview
where orders.cust_id=custview.cust_id 
group by membership order by 2;
