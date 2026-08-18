SELECT
    job_id,
    min(po_date) as "earliest po_date"
FROM
    pos
GROUP BY
    job_id;