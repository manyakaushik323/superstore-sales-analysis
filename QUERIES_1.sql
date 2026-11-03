-- Region wise total sales
SELECT Region, sum(Sales) AS total FROM superstore
GROUP BY Region;

--Category and Sub-category wise total Sales
SELECT Category,"Sub-Category" ,SUM(Sales) as Total_Sales From superstore
GROUP BY Category,"Sub-Category";

--Monthly sales trend
SELECT substr("Order Date",7,4) AS YEAR,
substr("Order Date",4,2) AS MONTH,
SUM(SALES) FROM superstore
GROUP BY YEAR,MONTH;

--Query: List of customers who have never placed an order (LEFT JOIN + IS NULL)
-- Business question: Which customers have no orders, so we can target
-- them with an offer or follow-up?
SELECT c."Customer ID", c."Customer Name"
FROM customers c
LEFT JOIN orders o ON c."Customer ID" = o."Customer ID"
WHERE o."Order ID" IS NULL;

--Query: Category-wise total sales within each customer segment
SELECT c.Segment, o.Category , SUM(o.sales) AS Total_sales
FROM customers c INNER JOIN orders o on c."Customer ID" = o."Customer ID" 
GROUP BY c.Segment, o.Category;

-- Query: Customer name and segment for each order line (INNER JOIN)
-- Business question: Who placed each order, and which segment do they belong to?
-- Why INNER JOIN: We only want orders that match a customer, so unmatched
-- rows are excluded.
SELECT c."Customer Name", c.Segment, o."Order ID", o.Sales
FROM customers c 
INNER JOIN orders o on c."Customer ID"=o."Customer ID"
LIMIT 10;

-- Business question: Which sub-categories are our big sellers (sales above 100,000)?
-- Why HAVING: WHERE filters rows before grouping; HAVING filters groups after SUM.
SELECT "Sub-Category", sum(Sales) AS total_sales FROM superstore
GROUP BY "Sub-Category"
HAVING total_sales>100000
ORDER BY total_sales DESC;

-- Business question: Which order lines are bigger than the average order line?
-- Why subquery: the average is calculated first, then used as a filter.
SELECT "Order ID", "Product Name", Sales
FROM orders
WHERE Sales > (SELECT AVG(Sales) FROM orders)
ORDER BY Sales DESC
LIMIT 10;

--Which 5 states generate the most sales?
SELECT State, SUM(Sales)  AS total_sales FROM superstore
GROUP BY State
ORDER BY total_sales DESC 
LIMIT 5;

-- Business question: What is the average value of a single order?
-- Why subquery: an order has many lines, so we first total each order,
-- then average those totals.
SELECT AVG(total_sales) AS avg_order_value 
FROM
(SELECT "Order ID", SUM(Sales) AS total_sales
FROM orders
GROUP BY "Order ID" ) AS T

-- Loyal Customers (without JOIN)
SELECT "Customer Name", COUNT(DISTINCT "Order ID") AS num_orders 
from superstore 
GROUP BY "Customer Name"
HAVING num_orders>10 ;
-- Loyal Customers (with join)
SELECT c."Customer Name",COUNT(DISTINCT o."Order ID") AS num_orders 
FROM customers c
INNER JOIN orders o on c."Customer ID"=o."Customer ID"
GROUP BY c."Customer ID",c."Customer Name"
HAVING num_orders > 10;