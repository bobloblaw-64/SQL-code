--By Finlay Thomson (23953297)

CREATE TRIGGER trga_price_calculator
AFTER INSERT ON OrderItem
FOR EACH ROW
WHEN NEW.unitPrice IS NULL
BEGIN
    UPDATE OrderItem
    SET unitPrice = (
        SELECT p.basePrice + s.sizeSurcharge
        FROM Product p, SizeOption s
        WHERE p.productId = NEW.productId
        AND s.size = NEW.size
    )
    WHERE orderId = NEW.orderId 
    AND lineNo = NEW.lineNo;
END;

CREATE TRIGGER trgb_free_drink
AFTER INSERT ON OrderItem
FOR EACH ROW
WHEN NEW.lineTotal IS NULL
BEGIN
    UPDATE OrderItem
    SET lineTotal = (
        SELECT
            CASE
                WHEN (
                    (
                        SELECT SUM(quantity)
                        FROM OrderItem
                        JOIN SalesOrder USING (orderId)
                        WHERE memberId = so.memberId
                    ) % 10 < NEW.quantity
                )
                THEN (NEW.quantity - 1) * unitPrice
                ELSE NEW.quantity * unitPrice
            END
        FROM OrderItem
        JOIN SalesOrder so USING (orderId)
        WHERE orderId = NEW.orderId
        AND lineNo = NEW.lineNo
    )
    WHERE orderId = NEW.orderId
    AND lineNo = NEW.lineNo;
END;
