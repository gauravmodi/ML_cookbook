-- ----------------------------------------------------------------------------
-- #1
 SELECT DISTINCT(customerName)
  FROM customers AS c
  JOIN payments AS pay
    ON c.customerNumber = pay.customerNumber
 WHERE pay.amount > 100000;

-- OR
SELECT customerName
FROM customers c
WHERE EXISTS 
    (SELECT 1
    FROM payments p
    WHERE p.customerNumber = c.customerNumber
        AND amount > 100000)

-- #2
 SELECT p.productCode,
       p.productName,
       p.quantityInStock
  FROM products AS p
 WHERE p.buyPrice > (SELECT AVG(buyPrice)
                       FROM products);

-- ----------------------------------------------------------------------------- 
-- #3 (GOOD) Show the product name, product description, and product line for the 
-- product in each product line that has the highest volume of gross revenue
WITH 
    productrevenue AS (SELECT productCode,
                              SUM(quantityOrdered * priceEach) AS revenue
                         FROM orderdetails
                        GROUP BY productCode),
    productlinemax AS (SELECT productLine,
                              MAX(pr.revenue) AS revenue
                         FROM products AS p
                         JOIN productrevenue AS pr
                           ON p.productCode = pr.productCode
                        GROUP BY p.productLine)
SELECT p.productName,
       p.productDescription,
       p.productLine
  FROM products AS p
  JOIN productrevenue AS pr
    ON p.productCode = pr.productCode
  JOIN productlinemax AS plm
    ON p.productLine = plm.productlinemax
 WHERE pr.revenue = plm.revenue;

-- Site Answer
WITH cte1 AS (
    SELECT productCode, 
           SUM(quantityOrdered*priceEach) AS totalOrdered
      FROM orderdetails
     GROUP BY productCode
) 
SELECT productName, 
       productDescription,
       productLine
  FROM products p 
  JOIN cte1 
    ON p.productCode = cte1.productCode
 WHERE cte1.totalOrdered = (SELECT MAX(totalOrdered)
                              FROM cte1 
                              JOIN products p2 
                                ON p2.productCode = cte1.productCode
                             WHERE p2.productLine = p.productLine)

-- #4 Show the employee first name, last name, and job title for all employees 
--    with the job title of “Sales Rep”.
SELECT firstName,
       lastName,
       jobTitle
  FROM employees
 WHERE jobTitle = 'Sales Rep';

-- #5 (GOOD) We need to get some feedback from all of the employees who have sold 
-- Harley Davidson Motorcycles. Get a report of the employee first names and 
-- emails for all employees who have ever sold a Harley.
SELECT DISTINCT e.firstName, e.email
  FROM employees AS e
  JOIN customers AS c
    ON e.employeeNumber = c.SalesRepEmployeeNumber
  JOIN orders AS o
    ON c.customerNumber = o.customerNumber
  JOIN orderdetails AS od
    ON o.orderNumber = od.orderNumber
  JOIN products AS p
    ON od.productCode = p.productCode
 WHERE p.productName LIKE '%Harley%';

-- #6
-- We want to display information about customers from France and the USA. Show 
-- the customer name, the contact first and last name (in the same column), and 
-- the country for all of these customers.
SELECT c.customerName,
       (c.contactFirstName  + ' ' + c.contactLastName) AS contactName,  
       c.country
  FROM customers AS c
 WHERE country IN ('France', 'USA');

-- #7 
-- We want to dig into customer order history. Show each customer name, along 
-- with date of their intial order and their most recent order. Call the initial
--  order ‘first_order’ and the last one ‘last_order’. Also include any 
-- customers who have never made an order.
SELECT c1.customerName AS customer_name,
       MIN(o.orderDate) AS first_order,
       MAX(o.orderDate) AS last_order
  FROM customers AS c1
  JOIN orders AS o
    ON c1.customerNumber = o.customerNumber
 GROUP BY c1.customerName
UNION ALL 
SELECT c2.customerName AS customer_name,
       NULL first_order,
       NULL last_order
  FROM customers AS c2
 WHERE c2.customerNumber NOT IN (SELECT customerNumber
                                  FROM orders)
 ORDER BY customer_name;

-- Site Answer
SELECT customerName
, MIN(orderDate) AS first_order
, MAX(orderDate) AS last_order
FROM customers AS c 
LEFT JOIN orders AS o
ON c.customerNumber = o.customerNumber
GROUP BY customerName

-- #8
WITH 
    employee_order_count AS (SELECT e.employeeNumber, 
                                    e.officeCode,
                                    COUNT(o.orderNumber) AS total_orders
                               FROM employees AS e
                               LEFT JOIN customers AS c
                                 ON e.employeeNumber = c.salesRepEmployeeNumber
                               LEFT JOIN orders AS o
                                 ON c.customerNumber = o.customerNumber
                              GROUP BY e.employeeNumber, e.officeCode)

SELECT ofc.city,
       AVG(eoc.total_orders) AS avg_orders
  FROM employee_order_count AS eoc
  JOIN offices AS ofc
    ON eoc.officeCode = ofc.officeCode
 GROUP BY ofc.city;



-- #12
SELECT TOP 5
       (e.firstName+' '+e.lastName) AS employee_name,
       c.customerName AS customer_name,
       o.orderNumber AS orderNumber,
       SUM(od.quantityOrdered*od.priceEach) AS order_subtotal,
       o.status
  FROM orders AS o
  JOIN orderdetails AS od
    ON o.orderNumber = od.orderNumber
  JOIN customers AS c
    ON o.customerNumber = c.customerNumber
  JOIN employees AS e
    ON c.salesRepEmployeeNumber = e.employeeNumber
 WHERE o.status != 'Shipped'
 GROUP BY (e.firstName+' '+e.lastName), c.customerName, o.orderNumber, o.status 
 ORDER BY SUM(od.quantityOrdered*od.priceEach) DESC;



-- #19 (GOOD)
WITH 
    paid AS (SELECT p.customerNumber AS customerNumber,
                    c.customerName AS customerName,
                    SUM(p.amount) AS amountPaid
               FROM payments AS p
               JOIN customers AS c
                 ON p.customerNumber = c.customerNumber
              GROUP BY p.customerNumber, c.customerName),
 
    owed AS (SELECT o.customerNumber AS customerNumber, 
                    SUM(od.quantityOrdered * od.priceEach) AS amountOwed
               FROM orders AS o
               JOIN orderdetails AS od
                 ON o.orderNumber = od.orderNumber
              GROUP BY customerNumber)

SELECT pa.customerNumber,
       pa.customerName
  FROM paid AS pa
  JOIN owed AS ow
    ON pa.customerNumber = ow.customerNumber
 WHERE (pa.amountPaid - ow.amountOwed) < 0;


-- #21
SELECT c.customerName,
       c.state 
  FROM customers AS c
  JOIN employees AS e
    ON c.SalesRepEmployeeNumber = e.employeeNumber
  JOIN offices AS o
    ON e.officeCode = o.officeCode
 WHERE c.state = o.state;

-- #22
SELECT p.productVendor,
     SUM(p.quantityInStock) AS total_quantity
  FROM products AS p
 GROUP BY p.productVendor
 ORDER BY total_quantity DESC;


-- #23 GOOD
SELECT *,
       SUM(subTotal) OVER(ORDER BY Transaction_date)
  FROM (
    SELECT o.customerNumber AS CustNum,
           o.orderDate AS Transaction_date,
           -1*SUM(od.quantityOrdered*od.priceEach) AS subTotal
      FROM orderdetails AS od
      JOIN orders AS o
        ON od.orderNumber = o.orderNumber
     WHERE o.customerNumber = 363
     GROUP BY o.customerNumber, o.orderDate
    UNION
    SELECT p.customerNumber,
         p.paymentDate,
         p.amount
      FROM payments AS p
     WHERE p.customerNumber = 363)
AS a;

-- #23 
SELECT *,
       SUM(subTotal) OVER(ORDER BY Transaction_date) AS Total,
       LEAD(Transaction_date,1) OVER(ORDER BY Transaction_date) next_order_date,
       RANK() OVER(PARTITION BY YEAR(Transaction_date) ORDER BY subTotal DESC) AS Rank_1
  FROM (SELECT o.customerNumber AS CustNum,
               o.orderDate AS Transaction_date,
               -1*SUM(od.quantityOrdered*od.priceEach) AS subTotal
      FROM orderdetails AS od
      JOIN orders AS o
        ON od.orderNumber = o.orderNumber
     WHERE o.customerNumber = 363
     GROUP BY o.customerNumber, o.orderDate
    UNION
    SELECT p.customerNumber,
         p.paymentDate,
         p.amount
      FROM payments AS p
     WHERE p.customerNumber = 363) AS a;

-- #24
SELECT TOP 1 p.productName, 
       SUM(od.quantityOrdered) AS Total
  FROM products AS p
  JOIN orderdetails AS od
    ON p.productCode = od.productCode
 GROUP BY productName
 ORDER BY Total DESC;

-- #25 
SELECT DISTINCT(o.orderDate)
  FROM orders AS o
 WHERE o.orderDate IN (SELECT p.paymentDate
                         FROM payments AS p);

-- #26
SELECT Transaction_date,
       COUNT(*)
  FROM (SELECT o.orderDate AS Transaction_date
          FROM orders AS o
         UNION ALL
        SELECT p.paymentDate AS Transaction_date
          FROM payments AS p ) AS a
 GROUP BY Transaction_date;

 --#27
SELECT CONVERT(DECIMAL(38, 2), CAST(COUNT(order_count) AS FLOAT)/(SELECT COUNT(DISTINCT(c.customerNumber)) FROM customers AS c))
  FROM (SELECT (COUNT(o.customerNumber)) AS order_count
          FROM orders AS o
         GROUP BY o.customerNumber
        HAVING COUNT(o.customerNumber) > 1)
AS a;

-- #28 TOUGH

SELECT (e.firstName + ' ' + e.lastName) AS Employee_name,
       e.jobTitle,
       COUNT(c.customerNumber)
  FROM employees AS e
    JOIN customers AS c
    ON e.employeeNumber = c.salesRepEmployeeNumber
 WHERE e.employeeNumber IN (SELECT employeeNumber 
                           FROM employees 
                          WHERE jobTitle LIKE '%Manager%')
    OR e.reportsTo IN (SELECT employeeNumber 
                           FROM employees 
                          WHERE jobTitle LIKE '%Manager%')
 GROUP BY e.firstName, e.lastName, e.jobTitle;

 SELECT (e.firstName + ' ' + e.lastName) AS Employee_name,
       e.jobTitle,
       COUNT(c.customerNumber)
  FROM employees AS e
  JOIN customers AS c
    ON e.employeeNumber = c.salesRepEmployeeNumber
 WHERE e.employeeNumber IN (SELECT employeeNumber 
                           FROM employees 
                          WHERE jobTitle LIKE '%Manager%'
                          UNION 
                          SELECT employeeNumber
  FROM employees
 WHERE employeeNumber IN (SELECT reportsTo 
                           FROM employees 
                          WHERE jobTitle LIKE '%Manager%'))
 GROUP BY e.firstName, e.lastName, e.jobTitle;
-- VP
 SELECT employeeNumber
  FROM employees
 WHERE employeeNumber IN (SELECT reportsTo 
                           FROM employees 
                          WHERE jobTitle LIKE '%Manager%');


-- #29
SELECT e.firstname+" "+e.lastName,
       c.customerNumber,
       o.orderNumber,
       o.status
  FROM orders AS o
  JOIN customers AS c
    ON o.customerNumber = c.customerNumber
  JOIN employees AS e
    ON c.salesRepEmployeeNumber
 WHERE o.status IN ("Cancelled", "Resolved", "In Process", "On Hold")

SELECT e.firstName+ ' ' + e.lastName AS [Employee Name],
c.customerNumber,
       o.orderNumber,
       o.status
  FROM orders AS o 
  JOIN customers AS c
    ON o.customerNumber = c.customerNumber
  JOIN employees AS e
    ON c.salesRepEmployeeNumber = e.employeeNumber
 WHERE o.status IN ('disPuted', 'In Process', 'On Hold');


-- SELECT DISTINCT(status) FROM orders;

-- #30

SELECT SUM(quantityOrdered*priceEach) AS orderPrice
FROM orderdetails
GROUP BY orderNumber
HAVING SUM(quantityOrdered*priceEach) > 60000;

-- #31

SELECT od.orderNumber
  FROM orderdetails AS od
 GROUP BY od.orderNumber
 HAVING COUNT(od.productCode) = 1;

-- #32

SELECT o.comments
  FROM orders AS o
 WHERE o.comments IS NOT NULL 

-- # 33
SELECT *
  FROM country AS c
  JOIN countrylanguage AS cl
    ON c.Code = cl.CountryCode
 WHERE (cl.Language = 'french') AND (c.GNP > 10000) ;
-- #41
SELECT Name
  FROM (SELECT *,
       RANK() OVER(PARTITION BY Continent ORDER BY LifeExpectancy DESC) AS lifeRank
  FROM country) ctry
WHERE lifeRank = 1;

-- #43
WITH 
    cte1 AS(SELECT RANK() OVER(PARTITION BY Continent ORDER BY c.SurfaceArea DESC) AS AreaRank, 
                   *
              FROM country AS c)
SELECT * 
  FROM cte1
 WHERE AreaRank IN (1, 2, 3)  

-- #44
WITH 
countryRank AS (SELECT c1.Name, c1.Continent,
                       RANK() OVER(PARTITION BY c1.Continent ORDER BY c1.Population DESC) AS AreaRank
                  FROM country AS c1),
cityRank AS (SELECT c2.Name, ct.ID, 
                    RANK() OVER(PARTITION BY c2.Name ORDER BY ct.Population DESC) AS PopRank
               FROM country AS c2
               JOIN city AS ct ON c2.Code = ct.CountryCode
               WHERE c2.Name IN (SELECT Name FROM countryRank WHERE AreaRank < 4))
SELECT PopRank, 
       ct1.Name, 
       ct1.Population, 
       cr.AreaRank, 
       cr.Name,
       cr.Continent
  FROM cityRank AS ctr
  JOIN city AS ct1 ON ctr.ID = ct1.ID
  JOIN countryRank AS cr ON cr.Name = ctr.Name
 WHERE ctr.PopRank < 4;

-- # 86
SELECT p1.payment_id AS paymentId
  FROM payment AS p1
 ORDER BY p1.payment_id 
UNION 
 SELECT p2.payment_id  AS paymentId
  FROM payment AS p2
 ORDER BY p1.payment_id DESC;


  
select ticker,
      date_,close,
      LAG(close,1) OVER(PARTITION BY ticker) AS yesterday_price 
from acadgild.stocks
