INSERT INTO SalesOrder (orderId, memberId, storeId)
VALUES (6100, 2, 's1');

INSERT INTO OrderItem (orderId, lineNo, productId, size, quantity)
VALUES (6100, 1, 'p1', 'S', 1);

select lineTotal
from OrderItem
where orderId = 6100;