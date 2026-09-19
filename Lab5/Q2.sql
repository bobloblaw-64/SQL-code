CREATE TRIGGER log_table_trigger
AFTER INSERT ON po_items
FOR EACH ROW
WHEN NEW.quantity > (
    SELECT on_hand
    FROM items
    WHERE item_id = NEW.item_id
)

BEGIN
    INSERT INTO log_table (job_id, po_id, item_id, message)
    VALUES (new.job_id, new.po_id, new.item_id, 'Quantity exceeds on_hand amount');
END;
