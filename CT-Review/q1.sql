SELECT iName as Ingredient, (grams * 2) as Amount
FROM contains
WHERE rName = 'Cheese Toast';    