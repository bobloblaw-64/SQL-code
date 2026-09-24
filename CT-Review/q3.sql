SELECT r.name, SUM((c.grams * i.kJoule)) AS energy
FROM Recipe r JOIN contains c ON r.name = c.rName
    JOIN Ingredient i ON c.iName = i.name 
GROUP BY r.name
HAVING r.category = 'Dessert';