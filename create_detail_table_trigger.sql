CREATE TRIGGER detail_table_trigger
AFTER UPDATE ON detail_summary
FOR EACH ROW
EXECUTE FUNCTION update_summary_table();
