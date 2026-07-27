-- Run this in MySQL Workbench (while connected to jci)
-- Creates app user for backend — fixes "Db connection failed"

USE jci;

CREATE USER IF NOT EXISTS 'jci_app'@'localhost' IDENTIFIED BY '123456789';
GRANT ALL PRIVILEGES ON jci.* TO 'jci_app'@'localhost';
FLUSH PRIVILEGES;

SELECT 'jci_app user created — now run: npm start' AS status;
