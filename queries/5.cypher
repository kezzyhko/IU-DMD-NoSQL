MATCH (a1:actor {actor_id: 123})

MATCH path = shortestPath(
  (a1)-[*]-(a2:actor)
)

WHERE a2 <> a1

RETURN a2.actor_id as id, a2.first_name as name, a2.last_name as surname, (length(path) / 2) as degree_of_separation;