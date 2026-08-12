SELECT job_id, po_id
FROM po_items
WHERE quantity > 50 OR item_id = 'IRN';