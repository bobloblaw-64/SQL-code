SELECT
    item_id,
    sum(quantity) as "total quantity"
FROM
    po_items
GROUP BY
    item_id
HAVING
    "total quantity" < 10;