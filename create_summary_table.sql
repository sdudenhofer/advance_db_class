INSERT INTO summary_table (film_title, city, country, actors, total_paid, times_rented, store_id)
SELECT 
film_title, city, country, actor_firstname || ' ' || actor_lastname, COUNT(rental_id) as times_rented, store_id
FROM detail_summary
GROUP BY film_title, city, country, store_id