SELECT
    cust_id,
    count(*) as "Number of type N jobs"

FROM
    bookjobs

WHERE
    jobtype = 'N'

GROUP BY 
    cust_id;