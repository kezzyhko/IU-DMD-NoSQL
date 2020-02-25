MATCH (n) DETACH DELETE n;



LOAD CSV WITH HEADERS FROM "file:///category.csv" AS csv
CREATE (:category {category_id: toInteger(csv.category_id), name: csv.name, last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///film.csv" AS csv
CREATE (:film {film_id: toInteger(csv.film_id), title: csv.title, description: csv.description, release_year: csv.release_year, rental_duration: csv.rental_duration, rental_rate: csv.rental_rate, length: csv.length, replacement_cost: csv.replacement_cost, rating: csv.rating, last_update: csv.last_update, special_features: csv.special_features, fulltext: csv.fulltext});

LOAD CSV WITH HEADERS FROM "file:///language.csv" AS csv
CREATE (:language {language_id: toInteger(csv.language_id), name: csv.name, last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///actor.csv" AS csv
CREATE (:actor {actor_id: toInteger(csv.actor_id), first_name: csv.first_name, last_name: csv.last_name, last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///country.csv" AS csv
CREATE (:country {country_id: toInteger(csv.country_id), country: csv.country, last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///city.csv" AS csv
CREATE (:city {city_id: toInteger(csv.city_id), city: csv.city, last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///address.csv" AS csv
CREATE (:address {address_id: toInteger(csv.address_id), address: csv.address, address2: csv.address2, district: csv.district, postal_code: csv.postal_code, phone: csv.phone, last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///staff.csv" AS csv
CREATE (:staff {staff_id: toInteger(csv.staff_id), first_name: csv.first_name, last_name: csv.last_name, email: csv.email, active: csv.active, username: csv.username, password: csv.password, last_update: csv.last_update, picture: csv.picture});

LOAD CSV WITH HEADERS FROM "file:///store.csv" AS csv
CREATE (:store {store_id: toInteger(csv.store_id), last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///customer.csv" AS csv
CREATE (:customer {customer_id: toInteger(csv.customer_id), first_name: csv.first_name, last_name: csv.last_name, email: csv.email, activebool: csv.activebool, create_date: csv.create_date, last_update: csv.last_update, active: csv.active});

LOAD CSV WITH HEADERS FROM "file:///payment.csv" AS csv
CREATE (:payment {payment_id: toInteger(csv.payment_id), amount: csv.amount, payment_date: csv.payment_date});

LOAD CSV WITH HEADERS FROM "file:///inventory.csv" AS csv
CREATE (:inventory {inventory_id: toInteger(csv.inventory_id), last_update: csv.last_update});

LOAD CSV WITH HEADERS FROM "file:///rental.csv" AS csv
CREATE (:rental {rental_id: toInteger(csv.rental_id), rental_date: csv.rental_date, return_date: csv.return_date, last_update: csv.last_update});



LOAD CSV WITH HEADERS FROM "file:///film_category.csv" AS csv
MATCH (f:film {film_id: toInteger(csv.film_id)})
MATCH (c:category {category_id: toInteger(csv.category_id)})
MERGE (f)-[r:is]->(c)
ON CREATE SET r.last_update = csv.last_update;

LOAD CSV WITH HEADERS FROM "file:///film_actor.csv" AS csv
MATCH (f:film {film_id: toInteger(csv.film_id)})
MATCH (a:actor {actor_id: toInteger(csv.actor_id)})
MERGE (a)-[r:participates_in]->(f)
ON CREATE SET r.last_update = csv.last_update;

LOAD CSV WITH HEADERS FROM "file:///film.csv" AS csv
MATCH (f:film {film_id: toInteger(csv.film_id)})
MATCH (l:language {language_id: toInteger(csv.language_id)})
MERGE (f)-[:on]->(l);

LOAD CSV WITH HEADERS FROM "file:///city.csv" AS csv
MATCH (ci:city {city_id: toInteger(csv.city_id)})
MATCH (co:country {country_id: toInteger(csv.country_id)})
MERGE (ci)-[:belongs_to]->(co);

LOAD CSV WITH HEADERS FROM "file:///address.csv" AS csv
MATCH (a:address {address_id: toInteger(csv.address_id)})
MATCH (c:city {city_id: toInteger(csv.city_id)})
MERGE (a)-[:located_in]->(c);

LOAD CSV WITH HEADERS FROM "file:///staff.csv" AS csv
MATCH (sta:staff {staff_id: toInteger(csv.staff_id)})
MATCH (sto:store {store_id: toInteger(csv.store_id)})
MATCH (a:address {address_id: toInteger(csv.address_id)})
MERGE (sta)-[:works_at]->(sto)
MERGE (sta)-[:lives_at]->(a);

LOAD CSV WITH HEADERS FROM "file:///store.csv" AS csv
MATCH (s:store {store_id: toInteger(csv.store_id)})
MATCH (a:address {address_id: toInteger(csv.address_id)})
MATCH (m:staff {staff_id: toInteger(csv.manager_staff_id)})
MERGE (s)-[:located_at]->(a)
MERGE (s)-[:managed_by]->(m);

LOAD CSV WITH HEADERS FROM "file:///customer.csv" AS csv
MATCH (c:customer {customer_id: toInteger(csv.customer_id)})
MATCH (a:address {address_id: toInteger(csv.address_id)})
MATCH (s:store {store_id: toInteger(csv.store_id)})
MERGE (c)-[:lives_at]->(a)
MERGE (c)-[:buys_at]->(s);

LOAD CSV WITH HEADERS FROM "file:///payment.csv" AS csv
MATCH (p:payment {payment_id: toInteger(csv.payment_id)})
MATCH (c:customer {customer_id: toInteger(csv.customer_id)})
MATCH (s:staff {staff_id: toInteger(csv.staff_id)})
MATCH (r:rental {rental_id: toInteger(csv.rental_id)})
MERGE (p)-[:paid_by]->(c)
MERGE (p)-[:taken_by]->(s)
MERGE (p)-[:consists_of]->(r);

LOAD CSV WITH HEADERS FROM "file:///inventory.csv" AS csv
MATCH (i:inventory {inventory_id: toInteger(csv.inventory_id)})
MATCH (f:film {film_id: toInteger(csv.film_id)})
MATCH (s:store {store_id: toInteger(csv.store_id)})
MERGE (i)-[:consists_of]->(f)
MERGE (i)-[:located_at]->(s);

LOAD CSV WITH HEADERS FROM "file:///rental.csv" AS csv
MATCH (r:rental {rental_id: toInteger(csv.rental_id)})
MATCH (i:inventory {inventory_id: toInteger(csv.inventory_id)})
MATCH (c:customer {customer_id: toInteger(csv.customer_id)})
MATCH (s:staff {staff_id: toInteger(csv.staff_id)})
MERGE (r)-[:consists_of]->(i)
MERGE (r)-[:rented_by]->(c)
MERGE (r)-[:given_by]->(s);