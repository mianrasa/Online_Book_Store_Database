create database OnlineBookStore;
use OnlineBookStore;
create table AuthorTable
(first_name char(50),
last_name char(50),
author_id int primary key);

insert into AuthorTable values
('J.k.','Rowling',1),
('George R.R.','Martin',2),
('Stephen','King',3),
('Agatha','Christie',4),
('Jane','Austen',5);

create table BookTable
(title char(70),
author_id int,
Foreign Key (author_id) references AuthorTable(author_id),
price float,
genre char(50),
book_id int primary key);

insert into BookTable values
("Harry Potter and the Sorceresr's Stone",1,9.99,'Fantasy',1),
("Harry Potter and the Chamber of Secrets",1,10.99,'Fantasy',2),
("A Game of Thrones",2,12.99,'Fantasy',3),
("The Green Mile",3,8.99,'Fiction',4),
("And Then There Were None",4,7.99,'Mystery',5),
("Pride and Prejudice",5,6.99,'Classic',6);
create table CustomerTable
( 
first_name char (50),
last_name char (50),
email char(50),
address char(50),
city char(50),
state char(50),
Zip_code int,
Customer_Id int primary key
);
insert into CustomerTable values
('Jhon','Doe','jhon.doe@email.com','123 Main st','AnyTown','CA',12345,1),
('Jane','Smith','jane.smith@email.com','456 Oak rd','Someville','NY',67890,2),
('Bob','Jhonson','bob.jhonson@email.com','789 Maple Ave','Cityville','TX',54321,3),
('Alice','Williams','alice.williams@email.com','321 pine st','Townsville','FL',98765,4),
('Tom','Davis','tom.davis@email.com','159 Elm Ln','Villageton','PA',24680,5);

create table OrderTable
(
order_id int primary key,
order_date date,
total_amount float,
Customer_Id int,
Foreign Key (Customer_Id) references CustomerTable(Customer_Id)
);

insert into OrderTable values
(1,'2022-10-31',1234,1),
(2,'2023-11-30',2457,2),
(3,'2024-01-14',500,3),
(4,'2024-05-20',1500,1),
(5,'2024-01-14',500,3),
(6,'2024-05-20',1500,1),
(7,'2024-01-14',500,3),
(8,'2024-05-20',1500,1);

create table Order_Item_Table
(
order_item_id int,
order_id int,
Foreign Key (order_id) references OrderTable(order_id),
book_id int,
foreign key(book_id)references BookTable(book_id),
quantity int
);

insert into Order_Item_Table values
(1,1,1,1),
(2,1,2,1),
(3,2,3,1),
(4,3,4,1),
(5,3,5,1),
(6,4,6,1),
(7,5,1,2),
(8,5,3,1);

create table Inventory_Table
(
inventory_id int primary key,
book_id int,
foreign key(book_id) references BookTable(book_id),
stock_quantity int 
);

insert into Inventory_Table values
(1,1,50),
(2,2,40),
(3,3,30),
(4,4,60),
(5,5,45),
(6,6,25);

-- Task:1

create view joinTable as 
select bt.book_id,bt.price,ot.quantity from BookTable bt join Order_Item_Table ot;

select concat('Total revenue: ',sum(price*quantity))from joinTable;
select concat('Average Book price: ',avg(price))from BookTable;
select concat('Total orders: ',count(quantity))from Order_Item_Table;
select concat('Maximum price: ',max(price),' & Maximum price: ',min(price))from BookTable;
select concat('Total book quantiy from inventory table: ',sum(stock_quantity))from Inventory_Table;

 -- Task:2
select date_format(order_date, '%Y-%m') as OrderMonth, sum(total_amount) as TotalSales
from OrderTable
group by OrderMonth;

select genre as Genre, count(*) as NumberOfBooks
from BookTable
group by Genre;

select Customer_Id, count(*) as NumberOfOrders, sum(total_amount) as TotalAmountSpent
from OrderTable
group by Customer_Id;

select b.title as BookTitle, sum(i.stock_quantity) as TotalStockQuantity
from BookTable b
join Inventory_Table i on b.book_id = i.book_id
group by b.title;

select year(order_date) as OrderYear, sum(total_amount) as TotalSales
from OrderTable
group by OrderYear;

-- Task: 3

select date_format(order_date, '%Y-%m') as OrderMonth, sum(total_amount) as TotalSales
from OrderTable
group by OrderMonth
having TotalSales > 700;

select genre as Genre, count(*) as NumberOfBooks
from BookTable
group by Genre
having NumberOfBooks > 3;

select Customer_Id, count(*) as NumberOfOrders, sum(total_amount) as TotalAmountSpent
from OrderTable
group by Customer_Id
having NumberOfOrders > 2;

select b.title as BookTitle, sum(i.stock_quantity) as TotalStockQuantity
from BookTable b
join Inventory_Table i on b.book_id = i.book_id
group by b.title
having TotalStockQuantity > 50;

-- Task: 4

select o.order_id, c.first_name, c.last_name, c.email, o.order_date, o.total_amount, b.title, oi.quantity
from OrderTable o
join CustomerTable c on o.Customer_Id = c.Customer_Id
join Order_Item_Table oi on o.order_id = oi.order_id
join BookTable b on oi.book_id = b.book_id;

select c.Customer_Id, c.first_name, c.last_name, c.email
from CustomerTable c
left join OrderTable o on c.Customer_Id = o.Customer_Id
where o.order_id is null;

select a.author_id, a.first_name, a.last_name, count(b.book_id) as NumberOfBooks
from AuthorTable a
join BookTable b on a.author_id = b.author_id
group by a.author_id, a.first_name, a.last_name
having NumberOfBooks > 1;

select c.Customer_Id, c.first_name, c.last_name, sum(o.total_amount) as TotalSpent
from CustomerTable c
join OrderTable o on c.Customer_Id = o.Customer_Id
group by c.Customer_Id, c.first_name, c.last_name;