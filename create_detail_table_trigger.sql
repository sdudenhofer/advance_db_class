CREATE TRIGGER detail_table_trigger
AFTER UPDATE ON summary_table
FOR EACH ROW
EXECUTE FUNCTION update_summary_table();