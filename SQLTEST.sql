use bnine;
--- Task 1
select ID, mobile_phone
from (
select ID, mobile_phone, DATEDIFF(YY,birth_date,GETDATE()) as age
from customer_info
) a
where a.age between 25 and 50;

--- Task 2 
select product_name,
count(product_name) as n_product,
SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active_loans,
SUM(disbursed_amount) as disbursed_amount,
sum(case when (dpd between 30 and 60) and (disbursed_date < '2020-1-1' ) then disbursed_amount else 0 end) as conditinal_amount
from products
right join Agreements on (products.ID = product_id)
group by product_name

--- Task 3

select date , repayment,sum(repayment) over (partition by month1 order by date) as comm_payments
from (
select date, repayment, MONTH(date) as month1, DAY(date) as day1 
from payments 
)m

--- Task 4

select week, (check_in-check_out) as rooms
from 
(select week, count(check_in_date) as check_in
from (
select datepart(week,check_in_date) as week, datepart(year,check_in_date) as year,check_in_date
from reservations
) i
group by week) i
left join 
(select week1, count(check_out_date) as check_out
from (
select datepart(week,check_out_date) as week1, datepart(year,check_out_date) as year,check_out_date
from reservations
) o
group by week1) o
on (i.week = o.week1)

--Task 5
select  player_id, country,duration_of_all_session, shortest_session, longest_session, RANK() OVER (PARTITION BY country ORDER BY longest_session desc) rank
from(
select player_id, country, sum(minutes) as duration_of_all_session, min(minutes) as shortest_session, max(minutes) as longest_session
from(
select session_id, player_id,country,DATEDIFF(mi, start_time,end_time) as minutes 
from game_sessions
)o
group by o.player_id, o.country)a

