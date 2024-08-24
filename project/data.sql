INSERT INTO otus.unit(name)
VALUES ('unit');

INSERT INTO otus.manufacturer(name)
VALUES ('Samsung'),
       ('Apple'),
       ('LG'),
       ('Bosh');customer

INSERT INTO otus.product_category(name)
VALUES ('appliances');

INSERT INTO otus.product(name, manufacturer_fk, unit_fk, description)
VALUES ('Refrigerator', round(random() * 3 + 1)::int, 1, 'A piece of kitchen equipment that uses electricity to preserve food at a cold temperature'),
       ('Washing machine', round(random() * 3 + 1)::int, 1, 'A machine for washing clothes, sheets, and other things made of cloth'),
       ('Dishwasher', round(random() * 3 + 1)::int, 1, 'A machine that washes dirty plates, cups, forks, etc.'),
       ('Oven', round(random() * 3 + 1)::int, 1, 'The part of a cooker with a door, used to bake or roast food'),
       ('Microwave', round(random() * 3 + 1)::int, 1, 'An electric oven that uses waves of energy to cook or heat food quickly'),
       ('Coffee maker', round(random() * 3 + 1)::int, 1, 'A machine that makes coffee'),
       ('Toaster', round(random() * 3 + 1)::int, 1, 'An electric device for making toast'),
       ('Blender', round(random() * 3 + 1)::int, 1, 'An electric machine used in the kitchen for breaking down foods or making smooth liquid substances from soft foods and liquids'),
       ('Food processor', round(random() * 3 + 1)::int, 1, 'An electric machine that cuts, slices, and mixes food quickly'),
       ('Slow cooker', round(random() * 3 + 1)::int, 1, 'A large electric cooking pot (= container) with a lid that cooks food at a low temperature, so it can be left cooking for several hours'),
       ('Air fryer', round(random() * 3 + 1)::int, 1, 'A large electric cooking pot (= container) with a lid that fries food using mainly hot air with very little or no oil'),
       ('Rice cooker', round(random() * 3 + 1)::int, 1, 'A rice cooker or rice steamer is an automated kitchen appliance designed to boil or steam rice. It consists of a heat source, a cooking bowl, and a thermostat. The thermostat measures the temperature of the cooking bowl and controls the heat. Complex, high-tech rice cookers may have more sensors and other components, and may be multipurpose'),
       ('Stand mixer', round(random() * 3 + 1)::int, 1, 'A stand mixer is a versatile and powerful kitchen appliance that has become an essential tool for both professional chefs and home cooks. With its ability to effortlessly mix, whip, and knead ingredients, a stand mixer saves time and energy in the kitchen, allowing for more efficient and consistent results.'),
       ('Electric kettle', round(random() * 3 + 1)::int, 1, 'Electric kettles revolutionize water heating with speed, safety, and style, making daily routines easier and beverages more enjoyable.'),
       ('Juicer', round(random() * 3 + 1)::int, 1, 'A machine for removing juice from fruit or vegetables'),
       ('Electric griddle', round(random() * 3 + 1)::int, 1, 'The best thing about an electric griddle is the range of meals you can cook on it. Whether you’re making burgers, steaks, or breakfast classics, it’s always the right choice of kitchen equipment. The Hamilton Beach 3-in-1 electric griddle is specially made to pair this kind of versatility with quality cooking.'),
       ('Waffle maker', round(random() * 3 + 1)::int, 1, 'A waffle iron or waffle maker is a kitchen utensil used to cook waffles between two hinged metal plates. Both plates have gridded indentations to shape the waffle from the batter or dough placed between them. The plates are heated and the iron is closed while the waffle bakes'),
       ('Bread maker', round(random() * 3 + 1)::int, 1, 'A bread making machine or breadmaker is a home appliance for baking bread. It consists of a bread pan (or "tin"), at the bottom of which are one or more built-in paddles, mounted in the center of a small special-purpose oven. The machine is usually controlled by a built-in computer using settings input via a control panel.'),
       ('Ice cream maker', round(random() * 3 + 1)::int, 1, 'If ice cream is a regular part of your household’s routine, then investing in an ice cream maker is a sensible option. Few home cooking projects will bring as much satisfaction as scooping out your first creamy, mouth-watering ice cream.'),
       ('Pressure cooker', round(random() * 3 + 1)::int, 1, 'A cooking pan with a tightly fitting lid that allows food to cook quickly in steam under pressure'),
       ('Deep fryer', round(random() * 3 + 1)::int, 1, 'An electric machine for cooking food in enough hot oil or fat to cover it'),
       ('Vacuum cleaner', round(random() * 3 + 1)::int, 1, 'A machine that cleans floors and other surfaces by sucking up dust and dirt'),
       ('Steam mop', round(random() * 3 + 1)::int, 1, 'In our experience, steam mops are great for everyday maintenance of most sealed floors in your bathroom, kitchen, or high-traffic areas. We''ve put steam cleaning to the test ourselves in The Lab and at home, using dozens of the best and trendiest models from brands like Bissell, Tineco, Shark, and Dupray.'),
       ('Robot vacuum', round(random() * 3 + 1)::int, 1, 'Robotic Vacuum Cleaner is a machine or a small disc to be precise, which moves through the length and breath of your floors carrying out its cleaning assignment. Due to technological advancement in this new age, robotic vacuum cleaner cleans floors automatically without human intervention. This wonderful device maneuvers around table legs and corners of wherever it is vacuuming.'),
       ('Carpet cleaner', round(random() * 3 + 1)::int, 1, 'Carpet cleaning is performed to remove stains, dirt, and allergens from carpets. Common methods include hot water extraction, dry-cleaning, and vacuuming.'),
       ('Air purifier', round(random() * 3 + 1)::int, 1, 'An air purifier is a device that helps to improve indoor air quality by removing pollutants, allergens, and other harmful particles from the air. It works by drawing in the surrounding air, filtering it through various mechanisms, and then releasing clean and purified air back into the room.'),
       ('Humidifier', round(random() * 3 + 1)::int, 1, 'A humidifier is a household appliance or device designed to increase the moisture level in the air within a room or an enclosed space. It achieves this by emitting water droplets or steam into the surrounding air, thereby raising the humidity.')
ON CONFLICT (name) DO NOTHING;

UPDATE otus.product SET product_search = to_tsvector('english', name || ' ' || description);

INSERT INTO otus.product_category_ref(product_category_fk, product_fk)
SELECT 1, product.id FROM otus.product;
