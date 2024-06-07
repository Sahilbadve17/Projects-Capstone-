create database if not exists wallmartsalesdata;
use wallmartsalesdata
CREATE table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null ,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time TIME not null,
payment_methods varchar(15) not null,
cogs decimal(10,2) not null,
gross_marginpct float(11,9),
gross_income decimal(12,2) not null,
rating float (2,1) 
)

select * from sales;
-- feature engineering 
-- time of the day
SELECT 
    `time`, 
    CASE 
        WHEN `time` BETWEEN '00:00:00' AND '11:59:59' THEN 'morning'
        WHEN `time` BETWEEN '12:00:00' AND '15:59:59' THEN 'afternoon'
        ELSE 'evening'
    END AS time_of_date
FROM 
    sales;

ALTER TABLE sales add column time_of_day varchar(20);

update sales 
set  time_of_day = (
case 
when `time` between "00:00:0;0" and "12:00:00" then "morning"
when `time` between "12:01:00" and "16;00;00" then "afternoon"
else "evening"
end
);

-- day name 
select date, dayname(date) from sales;

alter table sales add column day_name varchar(10);

update sales 
set day_name = dayname(date);

-- month name 
select date ,
monthname(date)
from sales;

alter table sales add column month_name varchar(10) ;
 
 update sales 
 set month_name  = monthname(date);
 
 -- EDA
 -- - -- -- - - - --     ----- ----------------- -------------------- --------------  ------------  
 --  - - --  --               ------------     GENERIC ---- --------------------------------------------
 
 -- 1)  how many unique city does data have?
 select distinct city  from sales;
 
 -- 2) how many unique branches does each city have?
 select distinct branch from sales ;
 
 -- 3) in which has most branches ?
 select distinct city branches from sales;
 

-- -- - -- - -- ------------------------EDA  -------------------------               ---------------------------------------
-- -- - -- - - - - - -----------------PRODUCT ---------------------------------
-- How many unique product lines our data have?
select distinct `product line` from sales;

-- what is the most common payment method?
select payment, count(`payment`) as cnt from sales group by payment order by cnt desc;

--  what is the most selling product line??
select `product line`,count(`product line`) as cnt from sales group by `product line` order by cnt desc;
 
-- what is total revenue in month?
select month_name as month,
sum(total) as total_revenue 
 from sales
 group by month_name
 order by total_revenue;

select * from sales;

-- which month had the largest cogs?
select month_name as month , 
sum(cogs) as cogs from sales 
group by month_name
order by cogs desc;

-- which product line has the largest revenue?
SELECT 
`product line`, 
sum(total) AS total_revenue
from sales group by `product line`
order by total_revenue;

--   what is the city of the largest revenue 
select branch , city, sum(total) as total_revenue from sales group by city,branch order by total_revenue desc;

-- which product line has the largest vat
select `product line`, avg(`tax 5%`) as avg_tax
from sales 
group by `product line`
order by avg_tax;

-- which branch sold more products than average products sold
select branch, sum(quantity) as qty from sales group by branch having sum(quantity) > (select avg(quantity) from sales) ;

--  which is the most common product line by gender 
SELECT gender, `product line`, COUNT(Gender) AS total_cnt 
FROM sales 
GROUP BY Gender, `product line` 
ORDER BY total_cnt DESC;

-- what is the average rating of each product line
select `product line` ,avg(rating) as avgrating from sales 
group by `product line`
order by avgrating desc;

-- ------------------------------------------SALES---------------------------------------------------
-- 1) NUMBER OF SALES MADE IN EACH TIME FOR EACH DAY PER WEEKDAY
SELECT * FROM SALES;

SELECT time_of_day 	, COUNT(*) AS TOTAL_SALES FROM SALES
WHERE DAY_NAME = "TUESDAY"
GROUP BY  time_of_day  
order by TOTAL_SALES DESC;

-- WHICH CUSTOMER TYPE BRINGS MOST REVENUE????
select `customer type` , sum(total) as total_revenue from sales 
group by `customer type`
order by total_revenue desc;

-- which city has highest vat?
select city ,max(`tax 5%`) as highestvat from sales group by city order by highestvat desc;

-- which customer type pays the highest vat?
select `customer type` , avg(`tax 5%`) as vat from sales group by `customer type` order by vat desc;

-- ---------------------------------------CUSTOMER---------------------------------------------------
	-- HOW MANY UNIQUE CUSTOMER TYPES DOES DATA HAVE? 
    SELECT DISTINCT `CUSTOMER TYPE` FROM SALES;
    
    -- how many unique payment methods does our data have?
    select distinct payment from sales;
    
-- which customer type buys the most?
select `customer type` , count(*) as cstmcnt from sales 
group by `customer type`;

-- what is the gender of most customers?
select gender, count(*) as gender_cnt from sales 
group by gender 
order by gender_cnt desc;

-- what is the gender distribution per branch???

select gender,count(*) as gender_cnt from sales
where branch = "c"
group by gender 
order by gender_cnt;

-- WHICH TIME OF THE DAY CUSTOMERS GIVE AVERAGE RATING?
SELECT time_of_day , avg(rating) as avgrating from sales 
group by time_of_day
order by avgrating desc;

-- which time of the day do customers give most rating per branch?
select time_of_day , avg(rating) as avg_rating from sales
where branch = "C" 
group by time_of_day 
order by avg_rating desc;

-- which day of week has the best avg rating ????\
select day_name, avg(rating) as avg_rating from sales 
group by day_name 
order by avg_rating desc;

---- END ------------