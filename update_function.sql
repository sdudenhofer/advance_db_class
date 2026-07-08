CREATE FUNCTION function_update_summary_table (
	film_title VARCHAR(50),
	city VARCHAR(50),
	country VARCHAR(50),
	actors VARCHAR(200),
	total_paid DECIMAL(7,2),
	times_rented SMALLINT,
	store_id SMALLINT
)
RETURNS BOOLEAN AS $$
DECLARE passed BOOLEAN;
BEGIN
	INSERT INTO summary_table (film_title, city, country, actors, total_paid, times_rented, store_id)
	VALUES($1, $2, $3, $4, $5, $6, $7);

	RETURN passed;
END; $$ LANGUAGE plpgsql;