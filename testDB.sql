CREATE SCHEMA store;
CREATE TABLE store."Customer" (
    "CustomerID" character(6) NOT NULL,
    "LastName" character varying(20),
    "FirstName" character varying(10),
    "Address" character varying(50),
    "City" character varying(20),
    "State" character(2),
    "Zip" character(5),
    "Phone" character varying(15)
);


CREATE TABLE store."Order" (
    "ProductID" character(6) NOT NULL,
    "OrderID" character(6) NOT NULL,
    "CustomerID" character(6) NOT NULL,
    "PurchaseDate" date,
    "Quantity" integer,
    "TotalCost" money
);


CREATE TABLE store."Product" (
    "ProductID" character(6) NOT NULL,
    "ProductName" character varying(40),
    "Model" character varying(10),
    "Manufacturer" character varying(40),
    "UnitPrice" money,
    "Inventory" integer
);

ALTER TABLE store."Customer" ADD CONSTRAINT pk_customer PRIMARY KEY("CustomerID");
ALTER TABLE store."Product" ADD CONSTRAINT pk_product PRIMARY KEY("ProductID");
ALTER TABLE store."Order" ADD CONSTRAINT pk_order PRIMARY KEY("OrderID");
ALTER TABLE store."Order" ADD CONSTRAINT fk_order_customer FOREIGN KEY ("CustomerID") REFERENCES store."Customer"("CustomerID");
ALTER TABLE store."Order" ADD CONSTRAINT fk_order_product FOREIGN KEY ("ProductID") REFERENCES store."Product"("ProductID");

