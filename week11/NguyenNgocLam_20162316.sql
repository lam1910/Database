--question 1
select categoryname from categories;

--question 3
select c.categoryname, count(p.prod_id) 
from products p, categories  c 
where c.category = p.category 
group by c.categoryname;

--question 4
with tmp as 
(select prod_id from products
	except
select prod_id from orderlines)
select tmp.prod_id, p.title from tmp, products p where tmp.prod_id = p.prod_id;

--question  5
select country 
from customers 
group by country order by country asc;

--question 8
select orderdate, count(orderid) as "number_of_order" 
from orders 
group by orderdate order by orderdate desc;

--question 9
select sum(quantity) as total_product_brought 
from orderlines 
where orderdate = '2004-02-03';

--question 12
select customerid, count(orderid) as number_of_order 
from orders 
group by customerid 
having count(orderid) >= 3
order by number_of_order desc;

--question 13
select customerid, firstname || ' ' || lastname as fullname, city, state, country, region 
from customers
where creditcardexpiration = '2008/09';

--question 15
select count(orderid) as number_of_orders 
from orders 
where customerid = '19887';

--question 16


