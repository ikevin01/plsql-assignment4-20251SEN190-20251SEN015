-- Insert Customers
insert into customers (
   full_name,
   email,
   loyalty_tier
) values
   ( 'Alice Uwase',
     'alice@example.com',
     'GOLD' );
insert into customers (
   full_name,
   email,
   loyalty_tier
) values
   ( 'Bob Mugisha',
     'bob@example.com',
     'SILVER' );
insert into customers (
   full_name,
   email,
   loyalty_tier
) values
   ( 'Chantal Kaneza',
     'chantal@example.com',
     'BRONZE' );
insert into customers (
   full_name,
   email,
   loyalty_tier
) values
   ( 'David Nshimiyimana',
     'david@example.com',
     'PLATINUM' );

-- Insert Products
insert into products (
   product_name,
   unit_price,
   stock_qty,
   category
) values
   ( 'Laptop Stand',
     25.00,
     100,
     'Electronics' );
insert into products (
   product_name,
   unit_price,
   stock_qty,
   category
) values
   ( 'Wireless Mouse',
     15.50,
     150,
     'Electronics' );
insert into products (
   product_name,
   unit_price,
   stock_qty,
   category
) values
   ( 'USB-C Cable',
     8.00,
     300,
     'Accessories' );
insert into products (
   product_name,
   unit_price,
   stock_qty,
   category
) values
   ( 'Mechanical Keyboard',
     85.00,
     20,
     'Electronics' );
insert into products (
   product_name,
   unit_price,
   stock_qty,
   category
) values
   ( 'Out of Stock Item',
     45.00,
     0,
     'Accessories' );

-- Insert Initial Orders & Items
insert into orders (
   customer_id,
   total_amount,
   status
) values
   ( 1,
     125.50,
     'PROCESSED' );
insert into order_items (
   order_id,
   product_id,
   quantity,
   unit_price
) values
   ( 1,
     1,
     1,
     25.00 );
insert into order_items (
   order_id,
   product_id,
   quantity,
   unit_price
) values
   ( 1,
     4,
     1,
     85.00 );

insert into orders (
   customer_id,
   total_amount,
   status
) values
   ( 2,
     31.00,
     'PENDING' );
insert into order_items (
   order_id,
   product_id,
   quantity,
   unit_price
) values
   ( 2,
     2,
     2,
     15.50 );

commit;