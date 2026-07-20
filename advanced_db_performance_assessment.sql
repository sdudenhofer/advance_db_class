-- CREATE detail_table
CREATE TABLE detail_summary(
location VARCHAR(150),
store_id SMALLINT,
amount DECIMAL(5,2),
rental_rate DECIMAL(5,2),
difference DECIMAL(5,2),
actor_firstname VARCHAR(50),
actor_lastname VARCHAR(50),
film_title VARCHAR(50),
film_id SMALLINT,
rental_date TIMESTAMPTZ,
rental_id SMALLINT
);

--CREATE summary_table
CREATE TABLE summary_table(
location VARCHAR(150),
total_amount DECIMAL(7,2),
total_rental_rate DECIMAL(7,2),
total_difference DECIMAL(7,2),
date_generated TIMESTAMPTZ
);

--ADD DATA TO DETAIL TABLE
INSERT INTO detail_summary (location, store_id, amount, rental_rate, difference, actor_firstname, actor_lastname, film_title,
film_id, rental_date, rental_id)
SELECT city.city || ‘, ‘ || country.country as location, inventory.store_id, payment.amount, film.rental_amount, payment.amount – film.rental_amount AS difference, actor.firstname, actor.lastname, film.title, inventory.film_id, rental.rental_date, rental.rental_id
FROM rental
JOIN inventory on rental.inventory_id = inventory.inventory_id
JOIN store on inventory.store_id = store.store_id
JOIN address on store.address_id = address_id
JOIN city on address.city_id = city.city_id
JOIN country on city.country_id = country.country_id
JOIN payment on rental.rental_id = payment.rental_id
JOIN film on inventory.film_id = film.film_id
JOIN film_actor on film.film_id = film_actor.film_id
JOIN actor on film_actor.actor_id = actor.actor_id;

-- CREATE TRIGGER THAT WILL UPDATE SUMMARY TABLE
CREATE OR REPLACE FUNCTION update_summary_table_after_insert()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO summary_table(location, total_amount,
total_rental_rate, total_difference, date_generated)
SELECT title, location, SUM(amount), SUM(rental_rate), SUM(difference),
NOW()
FROM detail_summary
GROUP BY location;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER after_insert_detail_trigger
AFTER INSERT on detail_summary
FOR EACH STATEMENT
EXECUTE FUNCTION update_summary_table_after_insert();

--CREATE PROCEDURE TO REFRESH DATA IN BOTH SUMMARY AND DETAIL DATA
CREATE OR REPLACE PROCEDURE detail_summary_procedure()
LANGUAGE plpgsql as $$
BEGIN
DELETE FROM detail_summary;
DELETE FROM summary_table;
INSERT INTO detail_summary (city, country, store_id, amount, rental_rate, actor_firstname, actor_lastname,
film_title, film_id, rental_date, rental_id)
SELECT city.city || ', ' || country.country as location, inventory.store_id, payment.amount, film.rental_amount, 
payment.amount - film.rental_amount AS difference, actor.firstname, actor.lastname, film.title, inventory.film_id, 
rental.rental_date, rental.rental_id
FROM rental
JOIN inventory on rental.inventory_id = inventory.inventory_id
JOIN store on inventory.store_id = store.store_id
JOIN address on store.address_id = address_id
JOIN city on address.city_id = city.city_id
JOIN country on city.country_id = country.country_id
JOIN payment on rental.rental_id = payment.rental_id
JOIN film on inventory.film_id = film.film_id
JOIN film_actor on film.film_id = film_actor.film_id
JOIN actor on film_actor.actor_id = actor.actor_id;
END;$$;



