-- ============================================================================
-- CITS1402 Relational Database Management Systems
-- Project: Bubble Trouble
-- Mission 6: Business Queries
-- File: queries.sql
--
-- STUDENT INSTRUCTIONS
-- 1. Do NOT change the task headings, task numbers, or PRINT statements.
-- 2. Write exactly ONE SQLite query in each STUDENT QUERY area.
-- 3. Every query must end with a semicolon (;).
-- 4. Your query must work for ANY valid Bubble Trouble database.
-- 5. Do NOT hard-code answers from sample data.
-- 6. Do NOT create, alter, insert, update, or delete data in this file.
--
-- Recommended execution:
--     sqlite3 BubbleTrouble.db < queries.sql
-- ============================================================================

.headers on
.mode column
.nullvalue NULL

.print ''
.print '======================================================================'
-- IMPORTANT: Replace 12345678 below with your Student Number
.print ' Student ID: 23953297' 
.print ' CITS1402 - BUBBLE TROUBLE'
.print ' MISSION 6: BUSINESS QUERIES'
.print '======================================================================'
.print ''
.print 'Each task heading is followed by the output of the student query.'
.print ''

-- ============================================================================
-- Q1 - CURRENT MENU                                                        
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q1 - CURRENT MENU'
.print '----------------------------------------------------------------------'
.print 'Task: List productId, productName, category and basePrice for all'
.print '      ACTIVE products. Sort by category, then productName.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q1: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

SELECT productId, productName, category, basePrice
FROM Product
WHERE status = 'ACTIVE'
ORDER BY category, productName;

-- <<< END STUDENT QUERY Q1 >>>

.print '------------------------------ END Q1 ---------------------------------'

-- ============================================================================
-- Q2 - INGREDIENT REACH                                                   
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q2 - INGREDIENT REACH'
.print '----------------------------------------------------------------------'
.print 'Task: For each ingredient, display the ingredient name and the number'
.print '      of DISTINCT products whose recipes use it.'
.print '      Include ingredients that are currently used by no product.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q2: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

SELECT 
    ingredientName, 
    COUNT(DISTINCT productId) AS productCount
FROM Ingredient 
LEFT JOIN Recipe USING (ingredientId)
GROUP BY ingredientId, ingredientName;

-- <<< END STUDENT QUERY Q2 >>>

.print '------------------------------ END Q2 ---------------------------------'

-- ============================================================================
-- Q3 - STORE PERFORMANCE                                                
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q3 - STORE PERFORMANCE'
.print '----------------------------------------------------------------------'
.print 'Task: For each store, display the store name, number of DISTINCT orders'
.print '      and total revenue from priced OrderItem rows.'
.print '      Include stores that have not yet processed an order.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q3: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

SELECT 
    storeName,
    COUNT(DISTINCT orderId) AS numOrders,
    COALESCE(SUM(lineTotal), 0) AS totalRevenue
FROM Store
LEFT JOIN SalesOrder USING (storeId)
LEFT JOIN OrderItem USING (orderId)
GROUP BY storeId, storeName;

-- <<< END STUDENT QUERY Q3 >>>

.print '------------------------------ END Q3 ---------------------------------'

-- ============================================================================
-- Q4 - POPULAR PRODUCTS                                                
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q4 - POPULAR PRODUCTS'
.print '----------------------------------------------------------------------'
.print 'Task: Display each product whose total quantity sold is at least'
.print '      20 drinks. Show productName and total quantity sold.'
.print '      Display the most popular product first.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q4: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

SELECT 
    productName,
    SUM(quantity) AS totalQuantity
FROM Product JOIN OrderItem USING (productId)
GROUP BY productId, productName
HAVING totalQuantity >= 20
ORDER BY totalQuantity DESC;

-- <<< END STUDENT QUERY Q4 >>>

.print '------------------------------ END Q4 ---------------------------------'

-- ============================================================================
-- Q5 - ACTIVE PRODUCTS NEVER ORDERED                                   
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q5 - ACTIVE PRODUCTS NEVER ORDERED'
.print '----------------------------------------------------------------------'
.print 'Task: Using a SUBQUERY, find all ACTIVE products that have never'
.print '      appeared in any OrderItem. Return productId and productName.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q5: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

SELECT productId, productName
FROM Product
WHERE status = 'ACTIVE'
AND productId NOT IN (
    SELECT DISTINCT productId
    FROM OrderItem
);

-- <<< END STUDENT QUERY Q5 >>>

.print '------------------------------ END Q5 ---------------------------------'

-- ============================================================================
-- Q6 - HIGH-VALUE MEMBERS                                              
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q6 - HIGH-VALUE MEMBERS'
.print '----------------------------------------------------------------------'
.print 'Task: Find members whose total spending is STRICTLY GREATER than the'
.print '      average total spending of members who have spent more than zero.'
.print '      Return memberName and total spending.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q6: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

SELECT
    memberName,
    SUM(lineTotal) AS totalSpending
FROM Member
JOIN SalesOrder USING (memberId)
JOIN OrderItem USING (orderId)
GROUP BY memberId, memberName
HAVING totalSpending > (

    SELECT AVG(memTotal)
    FROM (
    SELECT SUM(lineTotal) AS memTotal
        FROM SalesOrder
        JOIN OrderItem USING (orderId)
        GROUP BY memberId
        HAVING memTotal > 0
    )
);

-- <<< END STUDENT QUERY Q6 >>>

.print '------------------------------ END Q6 ---------------------------------'

-- ============================================================================
-- Q7 - STORE BEST SELLERS                                              
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q7 - STORE BEST SELLERS'
.print '----------------------------------------------------------------------'
.print 'Task: For EACH store, return the product or products with the greatest'
.print '      total quantity sold at that store. TIES MUST BE RETAINED.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q7: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

WITH
    --for each store & product combo, what is the total quantity?
    store_prod_qty AS (    
        SELECT storeId, productId, SUM(quantity) AS totalQty
        FROM SalesOrder JOIN OrderItem USING (orderId)
        GROUP BY storeId, productId
    ),
    --for each store, what is the qty of the most sold product?
    store_max_prod AS (
        SELECT storeId, MAX(totalQty) AS maxQty
        FROM store_prod_qty
        GROUP BY storeId
    )

SELECT storeName, productName
FROM Store
    JOIN store_prod_qty USING (storeId)
    JOIN store_max_prod USING (storeId)
    JOIN Product USING (productId)
WHERE totalQty = maxQty;

-- <<< END STUDENT QUERY Q7 >>>

.print '------------------------------ END Q7 ---------------------------------'

-- ============================================================================
-- Q8 - ABOVE-CATEGORY PERFORMANCE                                     
-- ============================================================================
.print ''
.print '----------------------------------------------------------------------'
.print 'Q8 - ABOVE-CATEGORY PERFORMANCE'
.print '----------------------------------------------------------------------'
.print 'Task: Using a CORRELATED SUBQUERY, find products whose total quantity'
.print '      sold is STRICTLY GREATER than the average total quantity sold by'
.print '      products in the SAME category.'
.print '      Return productName, category and total quantity sold.'
.print '----------------------------------------------------------------------'

-- >>> STUDENT QUERY Q8: WRITE YOUR SINGLE SQLITE QUERY BELOW >>>

SELECT
    p.productName,
    p.category,
    SUM(oi.quantity) AS totalSold
FROM Product p
JOIN OrderItem oi USING (productId)
GROUP BY p.productId, p.productName, p.category
HAVING totalSold > (
    SELECT AVG(catTotal)
    FROM (
        SELECT SUM(oi2.quantity) AS catTotal
        FROM Product p2
        JOIN OrderItem oi2 USING (productId)
        WHERE p2.category = p.category
        GROUP BY p2.productId
    )
);

-- <<< END STUDENT QUERY Q8 >>>

.print '------------------------------ END Q8 ---------------------------------'

.print ''
.print '======================================================================'
.print ' END OF MISSION 6'
.print ' Review the output above carefully before submitting.'
.print '======================================================================'
.print ''
