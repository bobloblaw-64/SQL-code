SELECT po_id, SUM(quantity * price) AS total_cost
FROM po_items JOIN items USING (item_id)
WHERE price > (
    SELECT AVG(price) FROM items
)
GROUP BY po_id;