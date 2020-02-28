// given customer
MATCH (c1:customer {customer_id: 123})

// find films our customer watched
MATCH (c1)<-[:rented_by]-(:rental)-[:consists_of]->(:inventory)-[:consists_of]->(f1:film)

// find other people who watched the same
MATCH (c2)<-[:rented_by]-(:rental)-[:consists_of]->(:inventory)-[:consists_of]->(f1:film)
WHERE c2 <> c1

// find what those people watched becide the original movie
MATCH (c2)<-[:rented_by]-(:rental)-[:consists_of]->(:inventory)-[:consists_of]->(f2:film)
WHERE f2 <> f1

// metric to assess to which degree a movie is a good recommendation
// fulltext search by description to get the score of how similar descriptions of two movies are
CALL db.index.fulltext.queryNodes("fulltext_idx", f1.description) YIELD node, score
WHERE node = f2

// return results
RETURN DISTINCT f2.film_id as id, f2.title as title, sum(score) as score
ORDER BY score DESC
LIMIT 50;