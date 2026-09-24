SELECT "name" 
FROM Recipe
WHERE "name" NOT IN (
    SELECT rName 
    FROM contains c JOIN Ingredient i ON c.iName = i.name
    WHERE i.isVeg = 0 
); 