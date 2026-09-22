SELECT job_id, descr 
FROM bookjobs
WHERE cust_id IN (
    SELECT cust_id 
    FROM publishers
    JOIN ( 
        SELECT city, count(*)
        FROM publishers JOIN bookjobs USING (cust_id)
        GROUP BY city
        HAVING count(*) < 2)
    USING (city)
);
        

