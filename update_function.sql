CREATE FUNCTION function_update_summary_table (
	film_title VARCHAR(50),
	city VARCHAR(50),
	country VARCHAR(50),
	actors VARCHAR(200),
	total_paid DECIMAL(7,2),
	times_rented SMALLINT,
	store_id SMALLINT
)
RETURNS trigger AS $update_values$
DECLARE passed BOOLEAN;
BEGIN
	INSERT INTO summary_table (film_title, city, country, actors, total_paid, times_rented, store_id)
	VALUES($1, $2, $3, $4, $5, $6, $7);
END; $update_values$ LANGUAGE plpgsql;

CREATE TRIGGER detail_table_trigger
AFTER INSERT OR UPDATE ON detail_summary
FOR EACH ROW
EXECUTE FUNCTION update_values();
