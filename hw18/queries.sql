-- Get customer info. This query has a lot of join sql instructions and you should use indexes for this query optimization.
SELECT cust.first_name,
       cust.last_name,
       cust.gender,
       cust.birth_date,
       cont.name as country,
       reg.name as region,
       c.name as city,
       str.name as street,
       cl.name as language,
       t.name as title,
       bn.number as building_number,
       pc.name as postal_code
FROM customer.contact_data cd
         INNER JOIN customer.customer cust ON (cust.id = cd.customer_fk)
         INNER JOIN customer.country cont ON (cont.id = cd.country_fk)
         LEFT JOIN  customer.region reg ON (reg.id = cd.region_fk)
         LEFT JOIN customer.city c ON (c.id = cd.city_fk)
         LEFT JOIN customer.street str ON (str.id = cd.street_fk)
         LEFT JOIN customer.correspondence_language cl ON (cd.correspondence_language_fk = cl.id)
         LEFT JOIN customer.title t ON (cd.title_fk = t.id)
         LEFT JOIN customer.building_number bn ON (bn.id = cd.building_number_fk)
         LEFT JOIN customer.postal_code pc ON (pc.id = cd.postal_code_fk)
WHERE cust.id = 2048;


