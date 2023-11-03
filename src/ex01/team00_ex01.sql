CREATE TABLE nodes
(
    point1 varchar NOT NULL,
    point2 varchar NOT NULL,
    cost   numeric NOT NULL DEFAULT 0.0
);

INSERT INTO nodes (point1, point2, cost)
VALUES ('a', 'b', 10),
       ('b', 'a', 10),
       ('a', 'c', 15),
       ('c', 'a', 15),
       ('a', 'd', 20),
       ('d', 'a', 20),
       ('b', 'c', 35),
       ('c', 'b', 35),
       ('b', 'd', 25),
       ('d', 'b', 25),
       ('d', 'c', 30),
       ('c', 'd', 30);


WITH RECURSIVE trip AS (
   SELECT 1 path_length,
      0.0 AS total_cost,
      ARRAY [n.point1] path,
      n.point1 last_point
   FROM nodes n
   WHERE n.point1 = 'a'
   UNION
   SELECT t.path_length + 1,
      t.total_cost + n.cost,
      t.path || n.point2,
      point2
   FROM trip t
      JOIN nodes n ON t.last_point = n.point1
   WHERE n.point2 != ALL(t.path)
      OR(
         t.path_length = 4
         AND n.point2 = 'a'
      )
)
SELECT t.total_cost,
   t.path::VARCHAR tour
FROM trip t
WHERE t.path_length = 5
   AND(
      t.total_cost = (
         SELECT min(t2.total_cost)
         FROM trip t2
         WHERE t2.path_length = 5
      )
      OR t.total_cost = (
         SELECT max(t2.total_cost)
         FROM trip t2
         WHERE t2.path_length = 5
      )
   )
ORDER BY 1,
   2;

DROP TABLE nodes;