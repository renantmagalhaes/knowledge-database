# SQL - Structured Query Language

## DQL - Data Query Language

### SELECT

```
SELECT * FROM table_name;
```

```
SELECT field1, field2 FROM table_name;
```

## Create alias to table name and fields

```
SELECT p.code AS cod, p.description AS desc, p.price AS pri, p.product_code AS pd FROM products AS p; 
```

## DML - Data Manipulation Language

### INSERT
- To insert a registry in an existing table

```
INSERT INTO table_name (field) VALUES ('new_value_of_the_field');
```

- Insert multiple values at time

```
INSERT INTO table_name (field1, field2, field3) VALUES ('value1', value 2, value3);
```

### UPDATE
 To change the data values in one or more registries of a table
 
 * One value
``` 
UPDATE table_name set field_name = 'updated_value' WHERE identifier = name_id;
```
example: UPDATE product_type set description = 'desktops' WHERE code = 5;
    
* Several values
```
UPDATE table_name set field_name1 = 'value1', field_name2 = value2 WHERE identifier = name_id;
```
example: UPDATE product set description = 'Notebook', price = 2.800 WHERE code = 20;

**Warning**

```Always use WHERE when using a UPDATE, if not ALL values will be updated``` 

### DELETE
- To remove the registries of a table

```
DELETE FROM table_name WHERE identifier = name_id;
```
example: DELETE FROM product_types WHERE code = 3;

**Warning**

```Always use WHERE when using a DELETE, if not ALL values will be erased``` 

## DDL - Data Definition Language

### CREATE
To create a database, table or other objects

#### Database
```
CREATE DATABASE finances;

```
#### Table
```
CREATE TABLE product_type (code INT PRIMARY KEY, description VARCHAR(50));
```

### ALTER
To alter a the table structure or other object inside a database
```
ALTER TABLE product_type ADD weight DECIMAL(8,2);
```

### DROP
Used to erase a database, table, or other objects

#### Database
```
DROP DATABASE finances;
```
#### Table
```
DROP TABLE product_type;
```

## DCL - Data Control Language
Aspects of data and users permission to control who has access to manipulated data within the database.

### GRANT
Used to authorize an user to execute or set operations in the database
#### Select
```
GRANT SELECT ON product_type TO username;
```

### REVOKE

Used to remove or restrain the capacity of a user execute operations
```
REVOKE CREATE TABLE FROM username;
```

## DTL - Data Transaction Language
#### BEGIN
Set the beginning of an transaction, this transaction can be completed or not. 
```
CREATE TABLE 'product_type' (codigo INT PRIMARY KEY, description VARCHAR(50));
BEGIN TRANSACTION; -- start the transaction
INSERT INTO product_type VALUES ('Notebook');
INSERT INTO product_type VALUES ('Nobreak');
COMMIT; -- finish and record the transaction
```

#### COMMIT
Finishes a transaction.
```
CREATE TABLE 'product_type' (codigo INT PRIMARY KEY, description VARCHAR(50));
BEGIN TRANSACTION; -- start the transaction
INSERT INTO product_type VALUES ('Notebook');
INSERT INTO product_type VALUES ('Nobreak');
COMMIT; -- finish and record the transaction
```

#### ROLLBACK
Make all the changes since the last COMMIT be discarded
```
CREATE TABLE 'product_type' (codigo INT PRIMARY KEY, description VARCHAR(50));
BEGIN TRANSACTION; -- start the transaction
INSERT INTO product_type VALUES ('Notebook');
INSERT INTO product_type VALUES ('Nobreak');
ROLLBACK; -- all changes since the last BEGIN are undone
```