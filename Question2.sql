-- Find the avg. customer value per store by month for rentals in 2005. Please exclude the top & bottom 10% of customers by value from the analysis.

select * from rental;
select * from store;
select * from staff;
select * from payment p;
join rental r on r.rental_id = p.rental_id  
where EXTRACT(year from rental_date) = 2005


select p.rental_id,p.customer_id,p.staff_id,extract(month from rental_date) rental_month,amount 
from payment p
join rental r on r.rental_id = p.rental_id
join staff s on s.staff_id = p.staff_id
join store st on st.store_id = s.store_id
where EXTRACT(year from rental_date) = 2005


select s.store_id,p.customer_id,extract(month from rental_date) rental_month,count(*) rentedout,sum(amount) totalrental,avg(amount) avgrent
from payment p
join rental r on r.rental_id = p.rental_id
join staff s on s.staff_id = p.staff_id
join store st on st.store_id = s.store_id
where EXTRACT(year from rental_date) = 2005
group by s.store_id,p.customer_id,extract(month from rental_date) 
order by totalrental desc 


-- FINAL QUERY

; with cte as(
select *, row_number() over(order by totalrental desc) rownum
  from (select s.store_id,p.customer_id,extract(month from rental_date) rental_month
               ,count(*) rentedout,sum(amount) totalrental,avg(amount) avgrent
			from payment p
			join rental r on r.rental_id = p.rental_id
			join staff s on s.staff_id = p.staff_id
			join store st on st.store_id = s.store_id
			where EXTRACT(year from rental_date) = 2005
			group by s.store_id,p.customer_id,extract(month from rental_date) 
			order by totalrental desc)x)

select * from cte c 
where rownum > (select max(rownum)*10/100 from cte) 
and rownum < (select max(rownum)-max(rownum)*10/100 from cte) 
