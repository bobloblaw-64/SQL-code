
--bob's:
INSERT INTO SalesOrder (orderId, memberId, storeId)
VALUES (6969, 1, 's1');

INSERT INTO OrderItem (orderId, lineNo, productId, size, quantity)
VALUES (6969, 1, 'p1', 'S', 3);

--alice's:
INSERT INTO SalesOrder (orderId, memberId, storeId)
VALUES (420, 2, 's1');

INSERT INTO OrderItem (orderId, lineNo, productId, size, quantity)
VALUES (420, 1, 'p1', 'S', 3);