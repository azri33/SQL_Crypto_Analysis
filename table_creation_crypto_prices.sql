DROP DATABASE IF exists Crypto_Project;
CREATE DATABASE Crypto_Project;
USE Crypto_Project;



CREATE TABLE crypto_prices (
    date DATE,
    symbol VARCHAR(10),
    close_price DECIMAL(18,2)
);
