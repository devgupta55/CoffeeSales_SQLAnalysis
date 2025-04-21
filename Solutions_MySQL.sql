-- Question 1: Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
/*
select
	city_name,
	population,
	round((population*0.25),0) as CoffeeConsumers
from city
*/
-- Question 2: Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in last qtr of 2023
/*
select
	ct.city_name as CityName,
	sum(total) as TotalSales
from sales ss
inner join customers cs
on cs.customer_id = ss.customer_id
inner join city ct
on ct.city_id = cs.city_id
where 
	extract(year from sale_date) = 2023
    and
	extract(quarter from sale_date) = 4
group by CityName

*/
-- Question 3: Sales Count for Each Product
-- How many units of each coffee product have been sold?
/*
select
	ss.product_id,
	ps.product_name,
	count(sale_id) as TotalOrders
from sales ss
right join products ps 
on ps.product_id = ss.product_id

group by ss.product_id, ps.product_name
*/

-- Question 4: Average Sales Amount per City
-- What is the average sales amount per customer in each city?
/*
select
	ct.city_id,
	city_name,
    sum(ss.total) as TotalSales,
    count(distinct ss.customer_id) as CustomerCount,
    round(sum(ss.total)/count(distinct ss.customer_id),2)as AvgSalesPerCustomer
from sales ss
inner join customers cs
on cs.customer_id = ss.customer_id
inner join city ct
on ct.city_id = cs.city_id

group by ct.city_id,city_name
*/

-- Question 5: City Population and Coffee Consumers 
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- assumption: 25% of City Population are Coffee Consumers
/*
select
	ct.city_name,
	ct.population as CityPopulation,
	round(ct.population * 0.25) as EstimatedCoffeeConsumers
from city ct
*/
-- Question 6: Top Selling Products by City: 
-- What are the top 3 selling products in each city based on sales volume?
/*
select
*
from
(select
	ps.product_id,
	ps.product_name,
    ct.city_name,
	count(ss.sale_id) as TotalVolume,
    dense_rank() over (partition by ct.city_name order by count(ss.sale_id) desc) as Ranking
    
from sales ss
inner join products ps
on ps.product_id = ss.product_id
inner join customers cs
on cs.customer_id = ss.customer_id
inner join city ct
on ct.city_id = cs.city_id

group by 1,2,3) as t1
where t1.Ranking<=3
*/

-- Question 7: Customer Segmentation by City: 
-- How many unique customers are there in each city who have purchased coffee products?
/*
select
ct.city_name,
count(distinct ss.customer_id) as UniqueCustomers
from sales ss
inner join customers cs
on cs.customer_id = ss.customer_id
inner join city ct
on ct.city_id = cs.city_id

group by 1
*/
-- Question 8: Impact of estimated rent on sales: 
-- Find each city and their average sale per customer and avg rent per customer
/*
select
	ct.city_name as CityName,
	sum(ss.total) as TotalSale,
	ct.estimated_rent as Rent,
	count(distinct cs.customer_id) as TotalCustomers,
	round(sum(ss.total)/count(distinct cs.customer_id),2) as AvgSalePerCustomer,
	round(ct.estimated_rent/count(distinct cs.customer_id),2) as AvgRentPerCustomer
from sales ss
inner join customers cs
on cs.customer_id = ss.customer_id
inner join city ct
on ct.city_id = cs.city_id
    
group by ct.city_name, ct.estimated_rent
order by TotalSale desc
*/

    

-- Question 9: Monthly Sales Growth: Sales growth rate: 
-- Calculate the percentage growth (or decline) in sales over different time periods (monthly).
/*
with MonthlySales as(
	select
		extract(month from sale_date) as Month,
		extract(year from sale_date) as Year,
		sum(total) as TotalSales
	from sales
	group by 1,2
),
LaggedSales as(
	select
		Month,
        Year,
        TotalSales,
        lag(TotalSales, 1, 0) over (partition by Year order by Month) as PrevMonthSales
	from MonthlySales
)
select
	Month,
	Year,
	TotalSales,
	-- PrevMonthSales,
    round((TotalSales-PrevMonthSales)*100/PrevMonthSales,2) as 'MonthlyGrowth(%)'
from LaggedSales
order by Year, Month
*/

-- Question 10: Market Potential Analysis: 
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, 
-- total customers, estimated coffee consumer
/*
select
	ct.city_name as CityName,
	ct.estimated_rent as Rent,
    count(distinct cs.customer_id) as TotalCustomers,
    population as Population,
    round((population * 0.25),0) as EstimatedCoffeeConsumers,
	sum(ss.total) as TotalSale
from sales ss
inner join customers cs
on cs.customer_id = ss.customer_id
inner join city ct
on ct.city_id = cs.city_id

group by 1,2,4

order by 6 desc

limit 3
*/
-- Recommendations & Reasons
-- Question 11: 
-- City 1: Pune
-- Question: Average rent per customer is very low.
-- Question: Highest total revenue.
-- Question: Average sales per customer is also high.
-- Question: City 2: Delhi
-- Question: Highest estimated coffee consumers at 7.7 million.
-- Question: Highest total number of customers, which is 68.
-- Question: Average rent per customer is 330 (still under 500).
-- Question: City 3: Jaipur
-- Question: Highest number of customers, which is 69.
-- Question: Average rent per customer is very low at 156.
-- Question: Average sales per customer is better at 11.6k.