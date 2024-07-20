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