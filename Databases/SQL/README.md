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
INSERT INTO table_name (field1, field2, field2) VALUES ('value1', value 2, value3);
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

# DDL - Data Definition Language