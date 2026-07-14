CREATE DATABASE testdb;

CREATE USER 'test_user'@'%' IDENTIFIED BY 'user_password';

GRANT ALL PRIVILEGES ON testdb.* TO 'test_user'@'%';

FLUSH PRIVILEGES;