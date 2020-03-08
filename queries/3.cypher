MATCH (r:rental)-[:consists_of]->(i:inventory)-[:consists_of]->(f:film)-[:is]->(c:category)
RETURN f.title as title, collect(DISTINCT c.name) as categories, count(r) as times_rented;