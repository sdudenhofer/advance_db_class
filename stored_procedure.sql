CREATE PROCEDURE detail_summary_procedure()
LANGUAGE plpgsql
as $$
BEGIN 
DELETE FROM detail_summary;
DELETE FROM summary_table;
INSERT INTO detail_summary (city, country, store_id, amount, rental_rate, actor_firstname, actor_lastname,
film_title, film_id, rental_date, rental_id)
SELECT city.city, country.country, inventory.store_id, payment.amount, film.rental_rate, actor.first_name, 
actor.last_name, film.title, inventory.film_id, rental.rental_date, rental.rental_id
FROM rental
JOIN inventory on rental.inventory_id = inventory.inventory_id
JOIN staff on rental.staff_id = staff.staff_id
JOIN address on staff.address_id = address.address_id
JOIN city on address.city_id = city.city_id
JOIN country on city.country_id = country.country_id
JOIN payment on rental.rental_id = payment.rental_id
JOIN film on inventory.film_id = film.film_id
JOIN film_actor on film.film_id = film_actor.film_id
JOIN actor on film_actor.actor_id = actor.actor_id;
END;
$$
