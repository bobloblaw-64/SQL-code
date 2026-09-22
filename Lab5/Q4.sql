CREATE TRIGGER price_change
AFTER UPDATE OF price ON items 
FOR EACH ROW
BEGIN 
    INSERT INTO item_updates
    VALUES (OLD.item_id, OLD.price, NEW.price);
END;