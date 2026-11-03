CREATE TABLE type (
    id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE zelya (
    id INTEGER PRIMARY KEY,
    name TEXT,
    difficult INTEGER,
    type_id INTEGER,
    FOREIGN KEY (type_id) REFERENCES type(id)
);

CREATE TABLE ingredient (
    id INTEGER PRIMARY KEY,
    name TEXT,
    cost INTEGER
);

CREATE TABLE recept (
    zelya_id INTEGER,
    ingredient_id INTEGER,
    count INTEGER,
    PRIMARY KEY (zelya_id, ingredient_id),
    FOREIGN KEY (zelya_id) REFERENCES zelya(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredient(id)
);

INSERT INTO type (id, name) VALUES
(1, 'лечебное'),
(2, 'очаровывающее'),
(3, 'усыпляющее'),
(4, 'яд'),
(5, 'защитное'),
(6, 'восстанавливающее');

INSERT INTO zelya (id, name, difficult, type_id) VALUES
(1, 'Зелье здоровья', 1, 1),
(2, 'Зелье силы', 3, 1),
(3, 'Приворотное зелье', 5, 2),
(4, 'Зелье сна', 3, 3),
(5, 'Яд василиска', 4, 4),
(6, 'Зелье мудрости (особое)', 5, 1),
(7, 'Противоядие', 2, 1),
(8, 'Зелье невидимости', 6, 2),
(9, 'Защитный эликсир', 2, 5),
(10, 'Зелье бодрости', 1, 6),
(11, 'Сонный туман', 4, 3),
(12, 'Яд паука', 5, 4),
(13, 'Зелье мудрости (ночное)', 6, 1),
(14, 'Эликсир удачи', 3, 1),
(15, 'Зелье защиты', 4, 5),
(16, 'Приворотный настой', 5, 2),
(17, 'Зелье восстановления', 2, 6),
(18, 'Тихий сон', 3, 3);

INSERT INTO ingredient (id, name, cost) VALUES
(1, 'корень мандрагоры', 15),
(2, 'корень женьшеня', 20),
(3, 'слеза феникса', 50),
(4, 'кровь дракона', 40),
(5, 'чешуя змеи', 5),
(6, 'перо вороны', 3),
(7, 'лунный камень', 25),
(8, 'пыльца феи', 8),
(9, 'корень валерианы', 12),
(10, 'порошок мандрагоры', 30),
(11, 'клык василиска', 60),
(12, 'лепесток розы', 7),
(13, 'перо феникса', 35),
(14, 'экстракт белладонны', 18),
(15, 'серебряная пыль', 22),
(16, 'вода из источника', 4),
(17, 'слеза единорога', 75),
(18, 'коготь грифона', 45),
(19, 'корень полыни', 9),
(20, 'сушёный папоротник', 6);

INSERT INTO recept (zelya_id, ingredient_id, count) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 3),
(2, 7, 1),
(3, 3, 1),
(3, 8, 2),
(4, 1, 1),
(4, 6, 2),
(5, 4, 2),
(5, 5, 3),
(6, 7, 2),
(6, 8, 1),
(7, 5, 2),
(8, 10, 2),
(8, 15, 1),
(8, 17, 1),
(9, 11, 1),
(9, 15, 2),
(9, 16, 3),
(10, 9, 2),
(10, 12, 2),
(10, 16, 1),
(11, 10, 1),
(11, 14, 2),
(11, 16, 2),
(12, 11, 2),
(12, 14, 1),
(12, 18, 1),
(13, 13, 1),
(13, 17, 2),
(13, 19, 1),
(14, 12, 3),
(14, 15, 1),
(14, 16, 2),
(15, 11, 1),
(15, 18, 2),
(15, 19, 1),
(16, 12, 2),
(16, 13, 1),
(16, 17, 1),
(17, 9, 2),
(17, 13, 1),
(17, 16, 3),
(18, 10, 1),
(18, 14, 1),
(18, 19, 2);

-- 1
SELECT name FROM zelya WHERE difficult = 3;

-- 2
SELECT name FROM zelya WHERE difficult > 3 ORDER BY difficult DESC, name ASC;

-- 3
SELECT name FROM ingredient WHERE name LIKE 'корень%';

-- 4
SELECT name FROM zelya WHERE name LIKE '%(%' AND name LIKE '%)%';

-- 5
SELECT name FROM zelya
UNION
SELECT name FROM ingredient;

-- 6
SELECT name FROM ingredient
WHERE id NOT IN (SELECT ingredient_id FROM recept);

-- 7
SELECT z.name
FROM zelya z
JOIN recept r ON z.id = r.zelya_id
WHERE r.ingredient_id = (SELECT id FROM ingredient ORDER BY cost DESC LIMIT 1);

-- 8
SELECT z.name, t.name, i.name, r.count
FROM recept r
JOIN zelya z ON r.zelya_id = z.id
JOIN type t ON z.type_id = t.id
JOIN ingredient i ON r.ingredient_id = i.id;

-- 9
SELECT AVG(cost) FROM ingredient;

-- 10
SELECT i.name, z.name
FROM ingredient i
LEFT JOIN recept r ON i.id = r.ingredient_id
LEFT JOIN zelya z ON r.zelya_id = z.id;

-- 11
SELECT t.name, AVG(z.difficult)
FROM type t
LEFT JOIN zelya z ON t.id = z.type_id
GROUP BY t.id, t.name;

-- 12
SELECT z.name
FROM zelya z
WHERE EXISTS (
    SELECT 1
    FROM recept r
    JOIN ingredient i ON r.ingredient_id = i.id
    WHERE r.zelya_id = z.id
      AND i.cost > 10
)
ORDER BY (
    SELECT SUM(i.cost * r.count)
    FROM recept r
    JOIN ingredient i ON r.ingredient_id = i.id
    WHERE r.zelya_id = z.id
);

-- 13
UPDATE ingredient
SET cost = cost * 2
WHERE name LIKE '%мандрагоры';

-- 14
UPDATE ingredient
SET cost = cost * 3
WHERE id NOT IN (
    SELECT r.ingredient_id
    FROM recept r
    JOIN zelya z ON r.zelya_id = z.id
    JOIN type t ON z.type_id = t.id
    WHERE t.name = 'очаровывающее'
);

-- 15
DELETE FROM recept
WHERE zelya_id IN (
    SELECT z.id
    FROM zelya z
    JOIN type t ON z.type_id = t.id
    WHERE t.name = 'усыпляющее'
);

-- 16
DELETE FROM recept
WHERE zelya_id IN (
    SELECT r.zelya_id
    FROM recept r
    JOIN ingredient i ON r.ingredient_id = i.id
    GROUP BY r.zelya_id
    HAVING SUM(i.cost * r.count) > (SELECT AVG(cost) FROM ingredient)
);