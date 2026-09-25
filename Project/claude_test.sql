PRAGMA foreign_keys = ON;

-- === Setup: minimal reference data ===
INSERT INTO Store VALUES ('S1', 'CBD Store', 'Perth', '2020-01-01');
INSERT INTO Member VALUES (1, 'Alice', 'alice@test.com', '5264579466', '2020-01-01'); -- valid BR5 card
INSERT INTO SizeOption VALUES ('S', 0.0), ('M', 0.5), ('L', 1.0);
INSERT INTO Product VALUES ('P1', 'Pearl Milk Tea', 'Milk Tea', 5.00, 'ACTIVE');

-- =========================================================
-- TEST 1: Trigger A — unitPrice auto-calculated when NULL
-- =========================================================
INSERT INTO SalesOrder VALUES (1001, 1, 'S1', '2026-01-10', '10:00');
INSERT INTO OrderItem (orderId, lineNo, productId, size, quantity, unitPrice, lineTotal)
VALUES (1001, 1, 'P1', 'M', 1, NULL, NULL);

SELECT 'TEST1 (expect unitPrice=5.5, lineTotal=5.5)' AS test,
       unitPrice, lineTotal
FROM OrderItem WHERE orderId=1001 AND lineNo=1;

-- =========================================================
-- TEST 2: explicit unitPrice must NOT be overwritten
-- =========================================================
INSERT INTO SalesOrder VALUES (1002, 1, 'S1', '2026-01-10', '10:05');
INSERT INTO OrderItem (orderId, lineNo, productId, size, quantity, unitPrice, lineTotal)
VALUES (1002, 1, 'P1', 'S', 1, 3.00, NULL);  -- explicit historical price

SELECT 'TEST2 (expect unitPrice=3.0 unchanged, lineTotal=3.0)' AS test,
       unitPrice, lineTotal
FROM OrderItem WHERE orderId=1002 AND lineNo=1;

-- =========================================================
-- TEST 3: price change AFTER a historical sale must not
-- retroactively change the old row (Section 3.6)
-- =========================================================
UPDATE Product SET basePrice = 99.00 WHERE productId = 'P1';

SELECT 'TEST3 (expect unitPrice STILL 5.5, not 99+)' AS test,
       unitPrice, lineTotal
FROM OrderItem WHERE orderId=1001 AND lineNo=1;

UPDATE Product SET basePrice = 5.00 WHERE productId = 'P1'; -- reset for later tests

-- =========================================================
-- TEST 4: loyalty boundary — build member up to 9 drinks,
-- then the 10th must be free
-- =========================================================
-- Member 1 already has 2 drinks from tests 1+2 (qty 1 + qty 1)
-- Add 6 more single-drink orders to reach 8 total
INSERT INTO SalesOrder VALUES (1003,1,'S1','2026-01-11','09:00');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1003,1,'P1','S',1,NULL,NULL);
INSERT INTO SalesOrder VALUES (1004,1,'S1','2026-01-11','09:05');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1004,1,'P1','S',1,NULL,NULL);
INSERT INTO SalesOrder VALUES (1005,1,'S1','2026-01-11','09:10');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1005,1,'P1','S',1,NULL,NULL);
INSERT INTO SalesOrder VALUES (1006,1,'S1','2026-01-11','09:15');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1006,1,'P1','S',1,NULL,NULL);
INSERT INTO SalesOrder VALUES (1007,1,'S1','2026-01-11','09:20');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1007,1,'P1','S',1,NULL,NULL);
INSERT INTO SalesOrder VALUES (1008,1,'S1','2026-01-11','09:25');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1008,1,'P1','S',1,NULL,NULL);
-- Member 1 now has 8 drinks total. Verify:
SELECT 'TEST4a (expect 8)' AS test, SUM(quantity)
FROM OrderItem JOIN SalesOrder USING(orderId) WHERE memberId=1;

-- 9th drink: should be charged normally
INSERT INTO SalesOrder VALUES (1009,1,'S1','2026-01-11','09:30');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1009,1,'P1','S',1,NULL,NULL);
SELECT 'TEST4b - 9th drink (expect lineTotal=5.0, NOT free)' AS test, lineTotal
FROM OrderItem WHERE orderId=1009 AND lineNo=1;

-- 10th drink: should be FREE
INSERT INTO SalesOrder VALUES (1010,1,'S1','2026-01-11','09:35');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (1010,1,'P1','S',1,NULL,NULL);
SELECT 'TEST4c - 10th drink (expect lineTotal=0.0, FREE)' AS test, lineTotal
FROM OrderItem WHERE orderId=1010 AND lineNo=1;

-- =========================================================
-- TEST 5: multi-quantity line spanning the threshold
-- (spec example: 8 previous + qty 3 => drinks 9,10,11;
-- exactly one free => charge for 2)
-- =========================================================
-- Use member 2, fresh, give them 8 drinks first
INSERT INTO Member VALUES (2, 'Bob', 'bob@test.com', NULL, '2020-01-01');
INSERT INTO SalesOrder VALUES (2001,2,'S1','2026-01-12','10:00');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (2001,1,'P1','S',8,NULL,NULL);
SELECT 'TEST5a (expect member2 total=8)' AS test, SUM(quantity)
FROM OrderItem JOIN SalesOrder USING(orderId) WHERE memberId=2;

-- Now buy 3 more in one line: drinks 9, 10, 11 -> only drink 10 is free
INSERT INTO SalesOrder VALUES (2002,2,'S1','2026-01-12','10:05');
INSERT INTO OrderItem (orderId,lineNo,productId,size,quantity,unitPrice,lineTotal) VALUES (2002,1,'P1','S',3,NULL,NULL);
SELECT 'TEST5b (expect lineTotal = 2*5.0 = 10.0)' AS test, lineTotal
FROM OrderItem WHERE orderId=2002 AND lineNo=1;

-- =========================================================
-- TEST 6: BR5 card checksum — invalid card should be rejected
-- =========================================================
-- This INSERT should FAIL (uncomment to test manually, since a
-- failure aborts the rest of a .sql script run via sqlite3 CLI
-- unless you wrap it or run it separately):
-- INSERT INTO Member VALUES (99, 'Bad', 'bad@test.com', '1234567890', '2020-01-01');