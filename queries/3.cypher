MATCH (f:film)-[:is]->(c:category)
MATCH (i:inventory)-[:consists_of]->(f)
MATCH (r:rental)-[:consists_of]->(i)
RETURN f.title as title, collect(DISTINCT c.name) as categories, count(r) as times_rented;