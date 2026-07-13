-- CREATE detail_table
CREATE TABLE detail_table (
	city varchar(50),
	country varchar(50),
	store_id SMALLINT,
	amount DECIMAL(5,2),
	rental_rate DECIMAL(5,2),
	actor_firstname varchar(50),
	actor_lastname varchar(50),
	film_title varchar(50),
	film_id SMALLINT,
	rental_date TIMESTAMP,
	rental_id smallint
);

--CREATE summary_table
CREATE TABLE summary_table (
    city VARCHAR(50),
    country VARCHAR(50),
    total_sales DECIMAL(7, 2),
    date_updated TIMESTAMP
);

--ADD DATA TO DETAIL TABLE
INSERT INTO detail_table (city, country, store_id, amount, rental_rate, actor_firstname, actor_lastname,
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

-- CREATE TRIGGER THAT WILL UPDATE SUMMARY TABLE
CREATE OR REPLACE FUNCTION update_summary_table_after_insert()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO summary_table(city, country, total_sales, date_updated)
	SELECT city, country, SUM(amount), NOW()
	FROM detail_summary
	GROUP BY city, country;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE trigger after_insert_detail_trigger
AFTER INSERT ON detail_table
FOR EACH STATEMENT
EXECUTE FUNCTION update_summary_table_after_insert();

--CREATE PROCEDURE TO REFRESH DATA IN BOTH SUMMARY AND DETAIL DATA
CREATE OR REPLACE PROCEDURE detail_summary_procedure()
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
$$;



