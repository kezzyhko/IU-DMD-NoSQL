MATCH (a1:actor)-[:participates_in]->(f:film)<-[:participates_in]-(a2:actor)

WITH count(f) as costarred, a1, a2

RETURN 	a1.actor_id as id, a1.first_name as name, a1.last_name as surname,
		collect({id: a2.actor_id, name: a2.first_name, surname: a2.last_name, costarred: costarred});