CREATE TABLE customer_lifecycle ( 
	customer_id bigint NOT NULL,
	revenue_first_30days bigint NOT NULL,
	first_film_rented varchar(50) NOT NULL, 
	last_film_rented varchar(50) NOT NULL,
	last_date_rented date NOT NULL,
	total_revenue bigint NOT NULL, 
	top3_fav_actors text NOT NULL, 
	PRIMARY KEY (customer_id)
);

DO $$
DECLARE
cid bigint; ffr varchar; lfr varchar; ldr date;
tr bigint;
t3fa text;
BEGIN
FOR cid IN SELECT customer_id FROM customer
LOOP
INSERT INTO customer_lifecycle (customer_id,revenue_first_30days,first_film_rented,last_film_rented,last_date_rented,total_revenue,top3_fav_actors)
values (cid, 1000, 'XXXX', 'XXXX', '2022-01-01', 1000, 'XXXX,YYYY,ZZZZ');
END LOOP; END$$;


-- A value tier based on the first 30 day revenue.


SELECT r.rental_date,SUM(amount) AS "Gross Revenue"
FROM rental r
INNER JOIN inventory i ON (i.inventory_id = r.inventory_id) 
INNER JOIN customer cus ON (cus.customer_id = r.customer_id) 
INNER JOIN payment p ON (p.rental_id = r.rental_id)
where cus.customer_id=565
GROUP by cus.email, r.rental_date 
ORDER BY r.rental_date asc 
limit 30

--The name of the last film they rented.

SELECT title
FROM film f
INNER JOIN inventory i ON (f.film_id = i.film_id)
INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
INNER JOIN customer cus ON (cus.customer_id = r.customer_id) 
where cus.customer_id=565
GROUP by f.title, cus.email, r.rental_date
ORDER BY r.rental_date
asc limit 1

-- Last rental date.

SELECT rental_date
FROM film f
INNER JOIN inventory i ON (f.film_id = i.film_id)
INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
INNER JOIN customer cus ON (cus.customer_id = r.customer_id) 
GROUP by r.rental_date
ORDER BY r.rental_date desc
limit 1

--Avg. time between rentals.

SELECT r.rental_date,SUM(amount) AS "Gross Revenue"
FROM rental r
INNER JOIN inventory i ON (i.inventory_id = r.inventory_id)
INNER JOIN customer cus ON (cus.customer_id = r.customer_id) 
INNER JOIN payment p ON (p.rental_id = r.rental_id)
where cus.customer_id=565
GROUP by cus.email, r.rental_date


--The top 3 favorite actors per customer.





SELECT cus.email as "Customer Email", act.first_name as "Actor First Name", count(act.first_name) as "Film Count"
FROM customer as cus
JOIN rental as ren ON cus.customer_id = ren.customer_id
JOIN inventory as inv ON ren.inventory_id = inv.inventory_id 
JOIN film_actor as fil ON inv.film_id = fil.film_id
JOIN actor as act ON act.actor_id = fil.actor_id
where cus.customer_id=524
group by cus.email,act.first_name
order by "Film Count" desc
limit 3


select * from customer

