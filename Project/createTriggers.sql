--By Finlay Thomson (23953297)

CREATE TRIGGER UnitPrice_and_LineTotal_Calc
AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
    --Trigger A, calculate unitPrice if its null
    UPDATE OrderItem
    SET unitPrice = (
        SELECT p.basePrice + s.sizeSurcharge
        FROM Product p, SizeOption s
        WHERE p.productId = NEW.productId
        AND s.size = NEW.size
    )
    WHERE orderId = NEW.orderId 
    AND lineNo = NEW.lineNo
    AND NEW.unitPrice IS NULL;

    -- Trigger B, caclulate line total if null
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
                THEN (NEW.quantity - 1) * unitPrice --price with free drink
                ELSE NEW.quantity * unitPrice --normal price
            END
        FROM OrderItem
        JOIN SalesOrder so USING (orderId)
        WHERE orderId = NEW.orderId
        AND lineNo = NEW.lineNo
    )
    WHERE orderId = NEW.orderId
    AND lineNo = NEW.lineNo
    AND NEW.lineTotal IS NULL;
END;
