SELECT
    po_id,
    sum(quantity) as "total quantity"
FROM
    po_items
GROUP BY
    po_id
HAVING
    "total quantity" > 50;