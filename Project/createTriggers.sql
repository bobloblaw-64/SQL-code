--By Finlay Thomson (23953297)

CREATE TRIGGER price_calculator
AFTER INSERT ON OrderItem
FOR EACH ROW
WHEN NEW.unitPrice IS NULL
BEGIN
    UPDATE OrderItem
    SET unitPrice = 