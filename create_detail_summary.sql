SELECT 
film_title, city, country, STRING_AGG(actor_firstname || ' ' || actor_lastname, ', ') as actors, COUNT(rental_id) as times_rented, 
rental_rate, (rental_rate * COUNT(rental_id)) as total_paid, store_id
FROM detail_summary
GROUP BY film_title, city, country, store_id, rental_rate