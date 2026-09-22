SELECT cust_id, "name"
FROM publishers
JOIN bookjobs USING (cust_id)
GROUP BY cust_id, "name"
having COUNT(*) > (
    SELECT AVG(job_count)
    FROM (
        SELECT COUNT(*) AS job_count
        FROM bookjobs
        GROUP BY cust_id
    ) AS counts
);