CREATE TABLE
    nodes (
        point1 VARCHAR NOT NULL,
        point2 VARCHAR NOT NULL,
        cost NUMERIC NOT NULL default 0
    );

INSERT INTO nodes VALUES ('a', 'b', 10);

INSERT INTO nodes VALUES ('b', 'a', 10);

INSERT INTO nodes VALUES ('a', 'c', 15);

INSERT INTO nodes VALUES ('c', 'a', 15);

INSERT INTO nodes VALUES ('a', 'd', 20);

INSERT INTO nodes VALUES ('d', 'a', 20);

INSERT INTO nodes VALUES ('b', 'd', 25);

INSERT INTO nodes VALUES ('d', 'b', 25);

INSERT INTO nodes VALUES ('c', 'd', 30);

INSERT INTO nodes VALUES ('d', 'c', 30);

INSERT INTO nodes VALUES ('b', 'c', 35);

INSERT INTO nodes VALUES ('c', 'b', 35);


SELECT *
From  nodes



WITH RECURSIVE paths (point1, point2, path, summa, step) AS (
    SELECT n1.point1,
        n1.point2,
        ARRAY [n1.point1, n1.point2 ] AS path,
        n1.cost AS SUMMA,
        1 AS step
    FROM nodes n1
    UNION ALL
    SELECT p.point1,
        n2.point2,
        p.path || ARRAY [n2.point2],
        p.summa + n2.cost,
        p.step + 1 as step
    FROM paths p
        JOIN nodes n2 ON p.point2 = n2.point1
        AND (
            n2.point2 != ALL(p.path)
            OR (
                n2.point2 = 'a'
                AND step = 3
            )
        )
)
SELECT p.summa AS total_cost,
    p.path::VARCHAR AS tour
FROM paths AS p
where p.point1 = 'a'
    AND p.point1 = p.point2
    AND p.summa = (
        SELECT min(summa)
        FROM paths
        WHERE point1 = point2
    )
ORDER BY 1,
    2;




WITH RECURSIVE paths (point1, point2, path, summa, step) AS (
    SELECT n1.point1,
        n1.point2,
        CONCAT(
            n1.point1,
            ',',
            n1.point2
        ) AS path,
        n1.cost AS SUMMA,
        1 AS step
    FROM nodes n1
    UNION ALL
    SELECT p.point1,
        n2.point2,
        CONCAT(
            p.path,
            ',',
            n2.point2
        ) AS path,
        p.summa + n2.cost,
        p.step + 1 as step
    FROM paths p
        JOIN nodes n2 ON p.point2 = n2.point1
        AND (
            (p.path NOT LIKE ('%' || n2.point2 || '%'))
            OR (
                n2.point2 = 'a'
                AND step = 3
            )
        )
)
SELECT p.summa AS total_cost,
    CONCAT('{', p.path, '}') AS tour
FROM paths AS p
where p.point1 = 'a'
    AND p.point1 = p.point2
    AND p.summa = (
        SELECT min(summa)
        FROM paths
        WHERE point1 = point2
    )
ORDER BY 1,
    2;