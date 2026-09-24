SELECT category, difficulty, count(*)
FROM Recipe
GROUP BY category, difficulty
HAVING count(*) >= 5;  