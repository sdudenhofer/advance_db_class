CREATE OR REPLACE FUNCTION f_update_summary_table ()
RETURNS TRIGGER AS $update_summary$
BEGIN
IF NEW.film_title, NEW.city, NEW.country, NEW.actors, NEW.total_paid, NEW.times_rented, NEW.store_id THEN
	INSERT INTO summary_table (film_title, city, country, actors, total_paid, times_rented, store_id)
	VALUES($1, $2, $3, $4, $5, $6, $7);
END IF;
	RETURN NEW;
END; $update_summary$ LANGUAGE plpgsql;

CREATE TRIGGER detail_table_trigger
AFTER UPDATE ON detail_summary
FOR EACH ROW
EXECUTE FUNCTION f_update_summary_table();
