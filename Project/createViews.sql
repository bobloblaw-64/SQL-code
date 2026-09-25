--By Finlay Thomson (23953297)
CREATE VIEW MonthlySales AS
SELECT
    SUBSTR(orderDate, 1, 7) AS orderMonth,
    storeName,
    productName,
    SUM(quantity) AS totalQuantity,
    SUM(lineTotal) AS totalRevenue

FROM Store JOIN SalesOrder USING (storeId)
JOIN OrderItem USING (orderId)
JOIN Product USING (productId)

WHERE lineTotal IS NOT NULL

GROUP BY orderMonth, storeId, storeName, productId, productName;

CREATE VIEW MemberSummary AS
SELECT
    memberId,
    memberName,
    COUNT(DISTINCT orderId) AS totalOrders,
    COALESCE(SUM(quantity), 0) AS totalDrinks,
    COALESCE(SUM(lineTotal), 0) AS totalSpent

FROM Member LEFT JOIN SalesOrder USING (memberId)
LEFT JOIN OrderItem USING (orderId)

GROUP BY memberId, memberName;