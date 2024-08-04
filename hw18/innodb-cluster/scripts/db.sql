CREATE DATABASE customer;
CREATE USER 'dbcustomer'@'%' IDENTIFIED BY 'dbcustomer';
GRANT ALL PRIVILEGES ON customer.* TO 'dbcustomer'@'%';

USE customer;

CREATE TABLE `customer` (
                            `id` bigint PRIMARY KEY AUTO_INCREMENT,
                            `first_name` varchar(50),
                            `last_name` varchar(50),
                            `birth_date` date,
                            `gender` ENUM ('Male', 'Female', 'Unknown'),
                            `marital_status` ENUM ('unmarried', 'married')
);

CREATE TABLE `country` (
                           `id` int PRIMARY KEY AUTO_INCREMENT,
                           `name` varchar(20) UNIQUE NOT NULL
);

CREATE TABLE `title` (
                         `id` int PRIMARY KEY AUTO_INCREMENT,
                         `name` varchar(30) UNIQUE NOT NULL,
                         `country_fk` int NOT NULL
);

CREATE TABLE `region` (
                          `id` int PRIMARY KEY AUTO_INCREMENT,
                          `name` varchar(30) UNIQUE NOT NULL,
                          `country_fk` int NOT NULL
);

CREATE TABLE `city` (
                        `id` int PRIMARY KEY AUTO_INCREMENT,
                        `name` varchar(50) UNIQUE NOT NULL,
                        `country_fk` int NOT NULL,
                        `region_fk` int
);

CREATE TABLE `street` (
                          `id` int PRIMARY KEY AUTO_INCREMENT,
                          `name` varchar(100) UNIQUE NOT NULL,
                          `city_fk` int
);

CREATE TABLE `building_number` (
                                   `id` int PRIMARY KEY AUTO_INCREMENT,
                                   `number` varchar(10) UNIQUE NOT NULL,
                                   `street_fk` int,
                                   `postal_code_fk` int
);

CREATE TABLE `postal_code` (
                               `id` int PRIMARY KEY AUTO_INCREMENT,
                               `name` varchar(30) UNIQUE NOT NULL
);

CREATE TABLE `correspondence_language` (
                                           `id` int PRIMARY KEY AUTO_INCREMENT,
                                           `name` varchar(15) UNIQUE NOT NULL,
                                           `country_fk` int NOT NULL
);

CREATE TABLE `contact_data` (
                                `id` bigint PRIMARY KEY AUTO_INCREMENT,
                                `customer_fk` bigint NOT NULL,
                                `country_fk` int NOT NULL,
                                `title_fk` int,
                                `region_fk` int,
                                `city_fk` int,
                                `street_fk` int,
                                `building_number_fk` int,
                                `postal_code_fk` int,
                                `correspondence_language_fk` int
);

ALTER TABLE `region` ADD FOREIGN KEY (`country_fk`) REFERENCES `country` (`id`);

ALTER TABLE `city` ADD FOREIGN KEY (`country_fk`) REFERENCES `country` (`id`);

ALTER TABLE `street` ADD FOREIGN KEY (`city_fk`) REFERENCES `city` (`id`);

ALTER TABLE `building_number` ADD FOREIGN KEY (`street_fk`) REFERENCES `street` (`id`);

ALTER TABLE `building_number` ADD FOREIGN KEY (`postal_code_fk`) REFERENCES `postal_code` (`id`);

ALTER TABLE `title` ADD FOREIGN KEY (`country_fk`) REFERENCES `country` (`id`);

ALTER TABLE `correspondence_language` ADD FOREIGN KEY (`country_fk`) REFERENCES `country` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`customer_fk`) REFERENCES `customer` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`country_fk`) REFERENCES `country` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`title_fk`) REFERENCES `title` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`region_fk`) REFERENCES `region` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`city_fk`) REFERENCES `city` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`street_fk`) REFERENCES `street` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`building_number_fk`) REFERENCES `building_number` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`postal_code_fk`) REFERENCES `postal_code` (`id`);

ALTER TABLE `contact_data` ADD FOREIGN KEY (`correspondence_language_fk`) REFERENCES `correspondence_language` (`id`);

ALTER TABLE `city` ADD FOREIGN KEY (`region_fk`) REFERENCES `region` (`id`);

CREATE TABLE temp_data (
                           title VARCHAR(30),
                           first_name varchar(50),
                           last_name varchar(50),
                           correspondence_language varchar(15),
                           birth_date varchar(40),
                           gender varchar(15),
                           marital_status varchar (15),
                           country varchar(20),
                           postal_code varchar(30),
                           region varchar(30),
                           city varchar(50),
                           street varchar(100),
                           building_number varchar(10)
);

LOAD DATA
    INFILE '/var/lib/mysql-files/some_customers.csv'
        INTO
        TABLE customer.temp_data
        FIELDS TERMINATED BY ","
        ENCLOSED BY '"'
        IGNORE 1 ROWS
        SET title = NULLIF(title, ''),
            first_name = NULLIF(first_name, ''),
            last_name = NULLIF(last_name, ''),
            correspondence_language = NULLIF(correspondence_language, ''),
            birth_date = NULLIF(birth_date, ''),
            gender = NULLIF(gender, ''),
            marital_status = NULLIF(marital_status, ''),
            country = NULLIF(country, ''),
            postal_code = NULLIF(postal_code, ''),
            region = NULLIF(region, ''),
            city = NULLIF(city, ''),
            street = NULLIF(street, ''),
            building_number = NULLIF(building_number, '');

INSERT INTO customer.country(name)
SELECT country FROM customer.temp_data ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO customer.title(name, country_fk)
SELECT DISTINCT td.title, c.id FROM customer.temp_data td
                                        INNER JOIN customer.country c ON (c.name = td.country)
WHERE td.title IS NOT NULL ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO customer.customer(first_name, last_name, birth_date, gender, marital_status)
SELECT first_name,
       last_name,
       IF (birth_date IS NOT NULL, CAST(birth_date as date), NULL),
       gender,
       marital_status
FROM customer.temp_data WHERE (first_name IS NOT NULL
    OR last_name IS NOT NULL
    OR birth_date IS NOT NULL
    OR gender IS NOT NULL
    OR marital_status IS NOT NULL);

INSERT customer.correspondence_language(name, country_fk)
SELECT DISTINCT td.correspondence_language, c.id FROM customer.temp_data td
                                                          INNER JOIN customer.country c ON (c.name = td.country)
WHERE td.correspondence_language IS NOT NULL ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT customer.region (name, country_fk)
SELECT DISTINCT td.region, c.id
FROM customer.temp_data td
         INNER JOIN customer.country c ON (c.name = td.country)
WHERE td.region IS NOT NULL ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT customer.city(name, country_fk, region_fk)
SELECT DISTINCT td.city, c.id, r.id
FROM customer.temp_data td
         INNER JOIN customer.country c ON (c.name = td.country)
         LEFT JOIN customer.region r ON (r.name = td.region) WHERE td.city IS NOT NULL
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT customer.street(name, city_fk)
SELECT DISTINCT td.street, c.id
FROM customer.temp_data td
         LEFT JOIN customer.city c ON (c.name = td.city)
WHERE td.street IS NOT NULL ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO customer.postal_code(name)
SELECT postal_code FROM customer.temp_data WHERE temp_data.postal_code IS NOT NULL
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO customer.building_number(number, street_fk, postal_code_fk)
SELECT DISTINCT td.building_number, s.id, c.id
FROM customer.temp_data td
         LEFT JOIN customer.street s ON (s.name = td.street)
         LEFT JOIN customer.postal_code c ON (c.name = td.postal_code)
WHERE td.building_number IS NOT NULL
ON DUPLICATE KEY UPDATE number = VALUES(number);

INSERT INTO customer.contact_data(customer_fk, country_fk, title_fk, region_fk, city_fk, street_fk, building_number_fk, postal_code_fk, correspondence_language_fk)
SELECT DISTINCT c.id, contr.id, ti.id, re.id, ci.id, str.id, bn.id, pc.id, cl.id FROM customer.temp_data td
                                                                                          INNER JOIN customer.customer c ON (
        (td.first_name IS NULL AND c.first_name IS NULL OR (td.first_name IS NOT NULL AND c.first_name IS NOT NULL AND td.first_name = c.first_name))
        AND (td.last_name IS NULL AND c.last_name IS NULL OR (td.last_name IS NOT NULL AND c.last_name IS NOT NULL AND td.last_name = c.last_name))
        AND ((td.birth_date IS NULL AND c.birth_date IS NULL)
        OR (c.birth_date IS NOT NULL AND td.birth_date IS NOT NULL AND CAST(td.birth_date as date) = c.birth_date))
        AND (td.gender IS NULL AND c.gender IS NULL OR (td.gender IS NOT NULL AND c.gender IS NOT NULL AND td.gender = c.gender))
        AND (td.marital_status IS NULL AND c.marital_status IS NULL OR (td.marital_status IS NOT NULL AND c.marital_status IS NOT NULL AND td.marital_status = c.marital_status)))
                                                                                          INNER JOIN customer.country contr ON (contr.name = td.country)
                                                                                          LEFT JOIN customer.title ti ON (ti.name = td.title)
                                                                                          LEFT JOIN customer.region re ON (re.name = td.region)
                                                                                          LEFT JOIN customer.city ci ON (ci.name = td.city)
                                                                                          LEFT JOIN customer.street str ON (str.name = td.street)
                                                                                          LEFT JOIN customer.building_number bn ON (bn.number = td.building_number)
                                                                                          LEFT JOIN customer.postal_code pc ON (pc.name = td.postal_code)
                                                                                          LEFT JOIN customer.correspondence_language cl ON (cl.name = td.correspondence_language);