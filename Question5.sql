-- Imagine that new rental data is being loaded into the database every hour. Assuming that the data is loaded sequentially, ordered by rental_date, re-purpose your logic for the customer_lifecycle table to process the new data in an incremental manner to a new table customer_lifecycle_incremental.

truncate customer_lifecycle_incremental

CREATE TABLE customer_lifecycle (
	customer_id bigint NOT NULL,
	revenue_first_30days bigint NOT NULL, 
	first_film_rented varchar(50) NOT NULL, 
	last_film_rented varchar(50) NOT NULL, 
	last_date_rented date NOT NULL, 
	total_revenue bigint NOT NULL, 
	top3_fav_actors text NOT NULL,
PRIMARY KEY (customer_id) );

DO $$
DECLARE
cid bigint; ffr varchar; lfr varchar; ldr date;
tr bigint;
t3fa text;
BEGIN
FOR cid IN SELECT customer_id FROM customer
LOOP
INSERT INTO customer_lifecycle_incremental (customer_id,revenue_first_30days,first_film_rented,last_film_rented,last_date_rented,total_revenue,top3_fav_actors) 
	values (cid, 1000,(SELECT title 
					   FROM film f
					   INNER JOIN inventory i ON (f.film_id = i.film_id) 
					   INNER JOIN rental r ON (i.inventory_id = r.inventory_id) 
					   INNER JOIN customer cus ON (cus.customer_id = r.customer_id)
					   where cus.customer_id=cid 
					   GROUP by f.title, cus.email, r.rental_date 
					   ORDER BY r.rental_date desc limit 1), 
			(SELECT title FROM film f 
			 INNER JOIN inventory i ON (f.film_id = i.film_id) 
			 INNER JOIN rental r ON (i.inventory_id = r.inventory_id) 
			 INNER JOIN customer cus ON (cus.customer_id = r.customer_id)
			 where cus.customer_id=cid 
			 GROUP by f.title, cus.email, r.rental_date
			 ORDER BY r.rental_date asc limit 1),
			(SELECT rental_date
			 FROM film f
			 INNER JOIN inventory i ON (f.film_id = i.film_id)
			 INNER JOIN rental r ON (i.inventory_id = r.inventory_id) 
			 INNER JOIN customer cus ON (cus.customer_id = r.customer_id) 
			 where cus.customer_id=cid 
			 GROUP by r.rental_date 
			 ORDER BY r.rental_date desc limit 1),1000, 'XXXX,YYYY,ZZZZ');
			 END LOOP; END$$;
			 
			 select * from customer_lifecycle_incremental