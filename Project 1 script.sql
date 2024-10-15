select * from mintclassics.products
where warehouseCode = 'a'

-- warehouse 'a' contains planes, motorcycles
-- warehouse 'b' contains classic cars
-- warehouse 'c' contains vintage cars
-- warehouse 'd' contains trucks and buses, trains, ships  


order by productLine;
select count(mintclassics.products.productLine) 
from mintclassics.products
where productline = 'Motorcycles';  

-- the count of motorcycle (productline) = 13 
-- the count of planes (productline) = 12

select count(mintclassics.products.productLine) 
from mintclassics.products
where productline = 'Planes';

select products.productName, products.warehouseCode, 
orderdetails.quantityOrdered, orderdetails.priceEach from orderdetails   
inner join products
on orderdetails.productCode = products.productCode;  

-- successfully joined orderdetails table with products table  
-- next ill attempt to join order details and orders using the order number 
create table analysis_archive as
select orderdetails.orderNumber, orders.customerNumber, customers.customerName, 
orderdetails.quantityOrdered, orders.orderDate, 
products.productCode, products.productName, products.productLine, products.quantityInStock,
products.warehouseCode from orders
left join orderdetails
on orders.orderNumber= orderdetails.orderNumber
left join products 
on orderdetails.productCode = products.productCode
left join customers
on orders.customerNumber= customers.customerNumber;


-- successfully joined orders, orderdetails, customers and products tables together
-- successfully created a table as "analysis archive and inserted the joined table
-- ANALYSIS !!!!! 

select * from analysis_archive;

select count(analysis_archive.customerNumber)
from analysis_archive
where analysis_archive.warehouseCode = "a";

-- orders for 657 vintage cars from warehouse "c"
-- orders for 1010 classic cars from warehouse "b"
-- orders for 695 planes, motorcycles, from warehouse "a" 
-- orders for  634  trucks and buses, trains, ships from warehouse"d"
-- 2996 in total
-- between 2003-01-06 and 2005-05-31 

select count(productName) from analysis_archive
where productLine = 'vintage cars';

-- determine which product didnt sell at all

select count(distinct analysis_archive.productCode) as ordered_procode
from analysis_archive;

--  there are 109 distinct products sold  

select count( products.productName)
from products;

-- and 110 distinct product names that can be sold
-- attempt to write a query to find the product name 
-- that was not sold at all in 2003-01-06 and 2005-05-31


create temporary table hh as
select distinct orderdetails.productCode as aap, products.productName, 
products.productLine, products.productCode as ppp
from orderdetails
right join products
on orderdetails.productCode = products.productCode
group by ppp;  

-- created a temp table to find the missing product code

select *, 
(case 
when (aap) = (ppp) 
then 'yes'
else 'no' 
end ) as yesorno
from hh;   

-- toyota supra (classic car) was not sold 
-- between 2003-01-06 and 2005-05-31


-- sum of quantity ordered for distinct product codes, names and lines
select distinct productName, sum(distinct quantityOrdered) as thesum, productCode, productLine
from analysis_archive
group by productCode, productName, productLine
order by thesum desc;

-- how many products are in each warehouse ?

select * from warehouses;

select * from products;
 
 select sum(distinct quantityinstock) as the_sum, productLine, warehouseCode
 from products  
 where warehouseCode = 'a'
 or warehouseCode = 'b'
 or warehouseCode = 'c'
 or warehouseCode = 'd'
 group by productLine, warehouseCode
;
 
 -- 555131 products
 -- 62287 planes in warehouse a
 -- 69401 motorcycles a
 -- 219183 classic cars b
 -- 124880 vintage cars c  
 -- 35851 trucks and buses d 
 -- 26833 ships d 
 -- 16696 trains d
 
 select sum(quantityInStock) AS sumit
 from products;
 
 select * from analysis_archive;
 
select sum(distinct quantityOrdered) as sumquantity_ordered, productLine,
 warehouseCode, count(distinct customerNumber) as customerc_count
from analysis_archive
where warehouseCode = 'a'
or warehouseCode = 'b'
or warehouseCode = 'c'
or warehouseCode = 'd'
group by productline, warehouseCode;  


-- customer analysis
select * from customers;

select count(orderNumber)
from orderdetails
where status= 'shipped';

-- there are 326 total orders
-- 303 were shipped   


select count( customerNumber) 
from orders
where status = 'shipped';
  
-- 326 orders from orders table with statuses
-- 2996 orders from order details table 

-- lets find out the difference between the orders table and orderdetails table 


create temporary table difftab as
select distinct orderdetails.orderNumber as orddeetsON, orders.orderNumber as ordON
 from orderdetails
 join orders on orderdetails.orderNumber=orders.orderNumber; 
 
 select * from difftab; 
 select *, 
(case 
when (orddeetsON) = (ordON) 
then 'yes'
else 'no' 
end ) as yesorno
from difftab
order by ordON DESC;  
 
 -- seems its just more orders
select * from analysis_archive;  
select count(orderNumber) from analysis_archive;



select sum(quantityOrdered) 
from analysis_archive
where productline like 'ship%'
group by productLine;   


-- find out how many each productline sold
-- 12778 motorcycles were ordered
-- 35582 classic cars were ordered
-- 11001 trucks
-- 22933 vintage cars
-- 11872 planes
-- 2818 trains
-- 8532 ships

select * from analysis_archive; 
select *
from orders
where status not like 'shipped'
order by orderNumber;