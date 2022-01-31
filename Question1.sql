
-- Find the top 10 most popular movies from rentals in H1 2005, by category.

select * from rental;
where rental_date between '01-jan-2005' and '30-jan-2005';

select * from category;

select * from film;

select * from rental
where rental_date between '01-jan-2005' and '30-jun-2005';

select * from inventory;

select * from film;

select * from rental join
where rental_date between '01-jan-2005' and '30-jun-2005'
select * from rental r join inventory i on r.inventory_id = i.inventory_id

select i.film_id,fc.category_id, c.name filmCategory,count(*)rentedOut
from rental r join inventory i on r.inventory_id = i.inventory_id
join film_category fc on fc.film_id = i.film_id
join category c on fc.category_id = c.category_id
where rental_date between '01-jan-2005' and '30-jun-2005'
group by i.film_id,fc.category_id,c.name
order by fc.category_id,rentedOut desc


select i.film_id,fc.category_id, c.name filmCategory,count(*)rentedOut
from rental r join inventory i on r.inventory_id = i.inventory_id
join film_category fc on fc.film_id = i.film_id
join category c on fc.category_id = c.category_id
where rental_date between '01-jan-2005' and '30-jun-2005'
group by i.film_id,fc.category_id,c.name
order by fc.category_id,rentedOut desc



-- select title,filmcategory,rentedout
select *
from(           
select *,row_number() over(partition by category_id order by rentedout desc) rank
from(   

select i.film_id,f.title,fc.category_id, c.name filmCategory,count(*)rentedOut
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on fc.film_id = i.film_id
join category c on fc.category_id = c.category_id
where rental_date between '01-jan-2005' and '30-jun-2005'
group by i.film_id,f.title,fc.category_id,c.name)x

)x
where rank = 1
limit 10


select * from rental
where rental_date between '2005-01-01 00:00:01' and '2005-06-30 23:59:59'
