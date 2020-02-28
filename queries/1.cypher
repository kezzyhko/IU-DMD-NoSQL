CALL {
	MATCH (r:rental)
	RETURN max(r.rental_date.year) as current_year
}

MATCH (cu:customer)<-[:rented_by]-(r:rental)-[:consists_of]->(:inventory)-[:consists_of]->(:film)-[:is]->(ca:category)

WHERE r.rental_date.year = current_year
WITH cu, count(DISTINCT ca.name) as categories_amount
WHERE categories_amount >= 2

RETURN cu.customer_id as id, cu.first_name as name, cu.last_name as surname;
//RETURN cu;