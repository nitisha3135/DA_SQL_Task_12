select * from sales

create table sales_report (
    product_id varchar primary key,
    total_quantity int,
    average_discount float
);

select * from sales_report
	
create or replace function update_sales_report()
returns trigger as $$
declare
    total_qty int;
    avg_discount float;
    record_count int;
begin
    select sum(quantity), avg(discount)
    into total_qty, avg_discount
    from sales
    where product_id = new.product_id;

    select count(*)
    into record_count
    from sales_report
    where product_id = new.product_id;

    if record_count = 0 then
        insert into sales_report values (new.product_id, total_qty, avg_discount);
    else
        update sales_report
        set total_quantity = total_qty, 
            average_discount = avg_discount
        where product_id = new.product_id;
    end if;

    return new;
end;
$$ language plpgsql;

create trigger update_sales_report_trigger
after insert or update on sales
for each row
execute function update_sales_report();

insert into sales(order_line, order_id, order_date, ship_date, ship_mode, customer_id, product_id, sales, quantity, discount, profit)
values (9998, 'CA-2016-152157', '2024-08-18', '2024-08-25', 'Second Class', 'CG-12521', 'FUR-BO-10002366', 150, 5, 0.15, 30);

update sales
set quantity = 10, discount = 0.10
where product_id = 'FUR-BO-10002366' and order_line = 9998;

select * from sales_report;

select * from sales order by order_line desc;

select sum(quantity), avg(discount)
from sales
where product_id = 'FUR-BO-10002366';



