SELECT po_id, count(item_id) as 'Items'
FROM po_items
GROUP BY po_id;
