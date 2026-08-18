SELECT MIN(on_hand * price) AS min, MAX(on_hand * price) AS max 
FROM items
WHERE on_hand >= 100;