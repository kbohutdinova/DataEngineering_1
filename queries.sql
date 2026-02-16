CREATE TABLE recipes AS
SELECT * FROM read_json_auto('2_Recipe_json.json');

CREATE TABLE flattened_recipes AS
SELECT
    recipe_title,
    category,
    subcategory,
    num_ingredients,
    num_steps,
    unnest(ingredients) AS ingredient_name
FROM recipes;

SELECT
    SUM(CASE WHEN recipe_title IS NULL THEN 1 ELSE 0 END) as null_titles,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) as null_categories,
    SUM(CASE WHEN ingredients IS NULL THEN 1 ELSE 0 END) as null_ingredients
FROM recipes;


SELECT * FROM recipes
WHERE num_ingredients <= 0 OR num_steps <= 0;

SELECT * FROM (
    SELECT
    category,
    recipe_title,
    num_steps,
    RANK() OVER (PARTITION BY category ORDER BY num_steps DESC) as complexity_rank
FROM recipes
)
WHERE complexity_rank <= 3
ORDER BY category, complexity_rank;

SELECT
    ingredient_name,
    COUNT(*) as usage_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) as popularity_rank
FROM flattened_recipes
GROUP BY ingredient_name
ORDER BY popularity_rank ASC
LIMIT 20;
