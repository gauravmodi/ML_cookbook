  -- SQL Practice 1

COUNT(*) returns the number of items in a group. This includes NULL values and duplicates.

COUNT(ALL expression) evaluates expression for each row in a group and returns the number of nonnull values.

COUNT(DISTINCT expression) evaluates expression for each row in a group and returns the number of unique, nonnull values.

-- -----------------------------------------------------------------------------
SELECT  M.senderid, (DATEDIFF(MAX(M.messagedt), MIN(M.messagedt)) + 1) AS tenure
  FROM  messages AS M
  JOIN  (SELECT name, email, personid FROM people WHERE email LIKE '%enron%') AS P
    ON  P.personid = M.senderid
 WHERE  (Year(M.messagedt) BETWEEN 1985 AND 2007)
   AND  P.email NOT LIKE 'no.address%'
GROUP BY M.senderid 
ORDER BY tenure DESC
 LIMIT  3;

-- -----------------------------------------------------------------------------
-- 13 a) Using Sub-query
SELECT  E.employeeNumber,
    E.lastName,
    E.firstName
  FROM  employees AS E
 WHERE  E.employeeNumber IN (SELECT DISTINCT C.salesRepEmployeeNumber
                 FROM customers AS C
                WHERE C.state = 'CA');

-- 13 b) Using Join
SELECT  DISTINCT E.employeeNumber,
    E.lastName,
    E.firstName
  FROM  customers AS C
LEFT JOIN employees AS E ON C.salesRepEmployeeNumber = E.employeeNumber
 WHERE  C.state = 'CA';


-- Window Function
function(...) OVER (
  PARTITION BY ...
  ORDER BY ...
  ROWS BETWEEN ... AND ...
)

-- Double quotes in SQL are used for object names such as Column names,
-- therefore always use single quotes

-- SQL is implemented as if a query was executed in the following order:

-- FROM clause
-- WHERE clause
-- GROUP BY clause
-- HAVING clause
-- SELECT clause
-- ORDER BY clause
-- There are exceptions though: MySQL and Postgres seem to have additional smartness that allows it.


SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 THEN '201-250'
            WHEN weight > 175 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players

SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 AND weight <= 250 THEN '201-250'
            WHEN weight > 175 AND weight <= 200 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players;

WITH 
  iphone1 (SELECT userid, date
            FROM iphone
           GROUP BY DATE_TRUNC('day', date), userid),
  web1    (SELECT userid, date
            FROM web
           GROUP BY DATE_TRUNC('day', date), userid)
SELECT COUNT(*) --i.userid, i.date, w.user, w.date
  FROM iphone1 AS i
  JOIN web1 AS w1 ON (i.userid = w.userid AND i.date = w.date)
