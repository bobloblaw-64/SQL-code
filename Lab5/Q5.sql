SELECT cust_id, "name"
FROM (
    SELECT cust_id, MAX(num)
    FROM (
        SELECT cust_id, COUNT(*) as num 
        FROM bookjobs
        GROUP BY cust_id
    )
)
JOIN publishers USING (cust_id);