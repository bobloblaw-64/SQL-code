CREATE TRIGGER delete_protector
BEFORE DELETE ON pos 
FOR EACH ROW
WHEN OLD.po_id in (
    SELECT DISTINCT po_id
    FROM po_items
)
BEGIN
    SELECT RAISE(ABORT, 'Cannot delete pos record with associated po_items');
END;