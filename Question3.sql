select * from(
select rank()over (partition by customer_id order by customer_id,film_id)rank,*
	from(
select distinct customer_id,film_id 
from rental r
join inventory i on r.inventory_id = i.inventory_id
--where customer_id = 1
order by customer_id,film_id)x)x
where rank <11


