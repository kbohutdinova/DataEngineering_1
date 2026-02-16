# 📘 Student Assignment: Working with Nested JSON Data

## Objective

The goal of this assignment is to practice working with **semi-structured JSON data**, transform it into a **structured format**, and perform **analytical queries using window functions** to extract meaningful insights.

---

## Task Description

### 1. Dataset Selection

* Find a dataset that:

    * Is stored in **JSON format**
    * Contains a **nested structure** (e.g. arrays, nested objects). The dataset must contain **both nested data and arrays.**
    * Has a size of **more than 10 MB**
* You may use:

    * [Kaggle](https://www.kaggle.com/)
    * Open data portals
    * Any other publicly available source

Examples of nested JSON structures:

* Arrays of objects
* Objects inside objects

---

### 2. Data Loading

* Load the dataset into an analytical environment.
* You may use:

    * DuckDB
    * BigQuery
    * Any other analytical database system that supports JSON

---

### 3. Data Parsing (Mandatory)

* Transform semi-structured JSON data into a **structured format** (tables with columns).
* This includes:

    * Flattening(unnest) arrays
    * Extracting nested fields
    * Casting data types where needed

The final result should be queryable using SQL.

---

### 4. Data Analysis Using Window Functions (Mandatory)

* Use **SQL window functions** to analyze the dataset.
* Provide **at least 2 data insights**.

Examples of insights:

* Top 3 companies by revenue per region
* Ranking users by activity within categories
* Running totals or moving averages over time
* Percentage contribution within a group

Each insight should include:

* SQL query
* Short explanation of the result

---

## Deliverables

* `README.md` (this file, extended with your work)
* SQL scripts or notebooks used for:

    * Loading data
    * Parsing JSON
    * Analysis
* Post it all on your GitHub and add a link to GitHub in Moodle.
---

## Evaluation Criteria

### Obligatory Part — **10 points**

| Criteria                                   | Points |
|--------------------------------------------|--------|
| Dataset > 10 MB with nested JSON structure | 1      |
| Correct data loading                       | 1      |
| Proper parsing of semi-structured data     | 2      |
| Use of window functions                    | 2      |
| At least 2 meaningful data insights        | 2      |
| Knowledge of theory*                       | 2      |
| **Total**                                  | **10** |

_*The Theoretical Questions section will help you prepare for the defense of your theoretical knowledge. The teacher has the right to rephrase the theoretical questions._


### Additional Task — **+2.5 points (Optional)**

Choose **one** of the following:

* Add **data quality checks** (nulls, duplicates, schema validation)
* Visualize results (charts or dashboards)

Clearly document the additional work in the README.

---

## Notes

* SQL clarity and readability matter.
* Reproducibility is important.
* Insights should be logical and data-driven, not trivial aggregations.
---
## My work

### Dataset 
I used https://www.kaggle.com/datasets/prashantsingh001/recipes-dataset-64k-dishes?resource=download&select=2_Recipe_json.json semi-structured dataset of cooking recipes. The data is stored in JSON format and contains arrays.

---

### Insights
#### 1) Top 3 Most Complex Recipes per Category

```
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
 ```

#### 2) Top Ingredient
```
SELECT
    ingredient_name,
    COUNT(*) as usage_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) as popularity_rank
FROM flattened_recipes
GROUP BY ingredient_name
ORDER BY popularity_rank ASC
LIMIT 20;
```

---
### Checks

Check is some rows null or not.
```
SELECT
    SUM(CASE WHEN recipe_title IS NULL THEN 1 ELSE 0 END) as null_titles,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) as null_categories,
    SUM(CASE WHEN ingredients IS NULL THEN 1 ELSE 0 END) as null_ingredients
FROM recipes;
```
Checkis table have some broken data like 0 or negative number.

```
SELECT * FROM recipes
WHERE num_ingredients <= 0 OR num_steps <= 0;
```
