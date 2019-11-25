--question 1
--a
select * 
from products 
where category = (select category from categories where categoryname = 'Documentary');

--b
with tmp as 
(select prod_id from products
	except
select prod_id from orderlines)
select tmp.prod_id, p.title from tmp, products p where tmp.prod_id = p.prod_id;

--c
with tmp as
(select customerid from customers
	except
select customerid from orders)
select customers.* from customers, tmp where customers.customerid = tmp.customerid;

--d
select country, count(customerid) as number_of_customers 
from customers 
group by country order by country asc;

--e
select ol.orderlineid, ol.prod_id, p.title as product_title, ol.quantity, p.price as unit_price, ol.quantity * p.price as amount 
from orderlines ol, products p 
where ol.prod_id = p. prod_id and ol.orderid = '942';

--f
select avg(totalamount) as average_order_value 
from orders;

--g
select * 
from products 
where prod_id in 
(
	select prod_id 
	from orderlines 
	group by prod_id 
	having sum(quantity) >= all(select sum(quantity) from orderlines group by prod_id)
);

--2

/*because NEW.quantity can be bigger than inventory.quan_in_stock so instead of making an after insert trigger, I made a before insert trigger to check 
if (NEW.quantity > inventory.quan_in_stock) then do not perform the insert
else update inventory and perform the insert*/ 

-- function for automatically update inventory when insert into orderlines table
create or replace function bf_i_orderlines returns trigger as
$$
begin
	select into tmp quan_in_stock from inventory where inventory.prod_id = NEW.prod_id;
	if (tmp < NEW.quantity) then return NULL;
	else
		update inventory set quan_in_stock = quan_in_stock - NEW.quantity
		where inventory.prod_id = NEW.prod_id;
		return NEW;
	end if;
end;
$$language plpgsql;

--drop existing trigger on orderlines with same name (if exist)
--drop trigger bf_insert_orderlines on orderlines;

create trigger bf_insert_orderlines
before insert on orderlines
for each row
execute bf_i_orderlines();  




