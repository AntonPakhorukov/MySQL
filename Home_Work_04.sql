DROP DATABASE IF EXISTS vk; -- удалить базу если существует vk
CREATE DATABASE vk; -- создаем базу vk
USE vk; -- используем базу vk

DROP TABLE IF EXISTS users;
CREATE TABLE users ( -- создали таблицу пользователей
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- UNSIGNED смещает праматр BIGINT c -/+ до 0/+
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

INSERT INTO users (id, firstname, lastname, email, phone) VALUES 
(1, 'Reuben', 'Nienow', 'arlo50@example.org', 89134568978),
(2, 'Frederik', 'Upton', 'terrence.cartwright@example.org', 89234568521),
(3, 'Unique', 'Windler', 'rupert55@example.org', 89271546325),
(4, 'Norene', 'West', 'rebekah29@example.net', 89234599889),
(5, 'Frederick', 'Effertz', 'von.bridget@example.net', 89235689745),
(6, 'Victoria', 'Medhurst', 'sstehr@example.net', 89458569874),
(7, 'Austyn', 'Braun', 'itzel.beahan@example.com', 89134857898),
(8, 'Jaida', 'Kilback', 'johnathan.wisozk@example.com', 89108529625),
(9, 'Mireya', 'Orn', 'missouri87@example.org', 89659932541),
(10, 'Jordyn', 'Jerde', 'edach@example.com', 89452657898);

SELECT * FROM users;

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (  -- Создали таблицу профиля пользователя
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `Photo_id`, `hometown`) 
VALUES 
(1, "М", "1988-10-08", "12354", "Москва"), 
(2, "М", "1990-09-29", "123524", "Пекин"),
(3, "Ж", "1985-04-27", "123354", "Париж"),
(4, "М", "1995-06-14", "12324", "Берлин"),
(5, "Ж", "1997-03-25", "1212354", "Иркутск"),
(6, "М", "1982-12-04", "1254", "Новосибирск"),
(7, "М", "1980-11-23", "1223354", "Тюмень"),
(8, "М", "1996-10-16", "1221354", "Якутск"),
(9, "М", "1992-01-13", "121135", "Симферопль"),
(10, "Ж", "1994-03-24", "12332154", "Красноярск");

SELECT * FROM profiles;


-- ДОМАШНЕЕ ЗАДАНИЕ 2:

/* Задание 1: Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, 
указанием индексов и внешних ключей) (CREATE TABLE)
*/

DROP TABLE IF EXISTS market_types;
CREATE TABLE market_types
(
Id SERIAL,
GroupName VARCHAR(30) NOT NULL
);

SELECT * FROM market_types;

DROP TABLE IF EXISTS market;
CREATE TABLE market
(
Id SERIAL,
MarketTypeId BIGINT UNSIGNED,
Manufacturer VARCHAR(30) NOT NULL,
ProductName VARCHAR(20) NOT NULL,
Price DECIMAL NOT NULL,
Body TEXT NOT NULL,
UserId BIGINT UNSIGNED,

FOREIGN KEY (UserId) REFERENCES users(id),
FOREIGN KEY (MarketTypeId) REFERENCES market_types(id),

INDEX market_Manufacturer_ProductName_idx(Manufacturer, ProductName)
);

SELECT * FROM market;

/* 
Задание 2: Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)
*/

INSERT INTO market_types(GroupName)
VALUES ('Smartphones_and_gadgets'), ('Laptops_and_computers'), ('TVs_and_digital_TV'), ('Audio'), ('Games_and_software'),
('Hobbies_and_entertainment'), ('Sporting_goods'), ('Photo_and_video'), ('Autoelectronics'), ('Accessories');

SELECT * FROM market_types;

INSERT INTO market(MarketTypeId, Manufacturer, ProductName, Price, Body)
VALUES 
(1, 'Apple', 'Iphone 8', 45000, 'Смартфон Apple, серия 8'),
(1, 'Apple', 'Iphone 9', 50000, 'Смартфон Apple, серия 8'),
(1, 'Apple', 'Iphone X', 56000, 'Смартфон Apple, серия 8'),
(1, 'Apple', 'Iphone 11', 62000, 'Смартфон Apple, серия 8'),
(1, 'Samsung', 'Galaxy S8', 38000, 'Смартфон Samsung, серия Galaxy S8'),
(1, 'Samsung', 'Galaxy S9', 45000, 'Смартфон Samsung, серия Galaxy S9'),
(1, 'Samsung', 'A13', 15000, 'Смартфон Samsung, серия A13'),
(1, 'Huawei', 'P20 PRO', 48000, 'Смартфон Huawei, серия P20 PRO'),
(1, 'Huawei', 'Nova Y90', 11000, 'Смартфон Huawei, серия Nova Y90'),
(1, 'Huawei', 'Mate 50 PRO', 65000, 'Смартфон Huawei, серия Mate 50 PRO');

SELECT * FROM market;

-- ДОМАШНЕЕ ЗАДАНИЕ 3:

/*
ЗАДАНИЕ 1: Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. [ORDER BY]
*/
#SELECT * FROM users;

SELECT DISTINCT firstname 
FROM users
ORDER BY firstname;

/*
ЗАДАНИЕ 2: Выведите количество мужчин старше 35 лет [COUNT]
*/

#SELECT * FROM profiles;

SELECT COUNT(CURRENT_DATE - birthday > 35) AS AgeMenOlder35
FROM profiles
WHERE gender = 'М';

/*
ЗАДАНИЕ 3: Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]
*/

#SELECT * FROM friend_requests;
/*
INSERT INTO friend_requests(initiator_user_id, target_user_id, status)
VALUES
(1, 3, 'requested'),
(4, 5, 'approved'),
(5, 2, 'declined'),
(7, 6, 'unfriended'),
(2, 1, 'requested'),
(6, 7, 'declined'),
(3, 4, 'approved'),
(6, 8, 'declined'),
(9, 4, 'approved'),
(6, 9, 'declined'),
(8, 9, 'unfriended');
*/
SELECT status, COUNT(*) AS Applications
FROM friend_requests
GROUP BY status;

/*
ЗАДАНИЕ 4: Выведите номер пользователя, который отправил больше всех заявок в друзья (таблица friend_requests) [LIMIT]
*/
/*
SELECT * FROM friend_requests;

SELECT initiator_user_id
FROM friend_requests
LIMIT ???;
*/


ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id -- изменить таблицу profiles добавить ограничение fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id) -- внешний ключ (user_id) ссылается на user(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (  -- создали таблицу сообщений
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL, -- от какого пользователя сообщение
    to_user_id BIGINT UNSIGNED NOT NULL, -- для какого пользователя сообщение
    body TEXT, -- текст сообщения
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id), -- ссылка на id отправителя сообщения 
    FOREIGN KEY (to_user_id) REFERENCES users(id) -- ссылка на id получателя сообщения
);

INSERT INTO messages(from_user_id, to_user_id, body)
VALUE
(1, 2, 'Hi'),
(1, 3, 'Hello'),
(3, 1, 'Hi, bro'),
(2, 5, 'I need help'),
(4, 5, 'You need my help?'),
(7, 8, 'Welcom in city'),
(3, 1, 'Pls, help two user'),
(1, 3, 'Ok'),
(3, 1, 'Thanks'),
(1, 3, 'I talk with him'),
(5, 1, 'Ops!');

SELECT * FROM messages;

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (  -- Создали таблицу запросов в друзья
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities( -- создали таблицу групп (сообщества)
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

INSERT INTO communities(name, admin_user_id)
VALUE ("Landscapes", 1), ("FavoriteMusic", 3), ("NewFilms", 5), ("GamblingAddiction", 7), 
("Designers", 2), ("Trips", 4), ("FavoriteArtists", 6);

SELECT * FROM communities;

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities( -- создали таблицу участников группы
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

INSERT INTO users_communities(user_id, community_id)
VALUE
(1, 2), (1, 3), (1, 6),
(2, 3), (2, 7),
(3, 1), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7),
(4, 1), (4, 5),
(5, 6),
(6, 2), (6, 3),
(7, 5), (7, 1), (7, 2),
(9, 4), (9, 5),
(10, 6), (10, 3), (10, 1), (10, 4);

SELECT * FROM users_communities;



#ДОМАШНЕЕ ЗАДАНИЕ 4:

/*
ЗАДАНИЕ 1: Подсчитать количество групп, в которые вступил каждый пользователь.
*/

#SELECT * FROM users_communities;

SELECT user_id, COUNT(*) AS InGroup 
FROM users_communities
GROUP BY user_id;

/*
ЗАДАНИЕ 2: Подсчитать количество пользователей в каждом сообществе.
*/

SELECT community_id AS GroupNumber, COUNT(*) AS UsersInGroup
FROM users_communities
GROUP BY community_id;

/*
ЗАДАНИЕ 3: Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, 
который больше всех общался с выбранным пользователем (написал ему сообщений).
*/

SELECT from_user_id, to_user_id, COUNT(from_user_id) AS Messages
FROM messages
WHERE to_user_id = 1 
GROUP BY from_user_id
ORDER BY COUNT(*) DESC
LIMIT 1;




DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types( -- создали группу типы медиа
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media( -- создали группу медиа
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

/*INSERT INTO media(media_type_id, user_id, body, filename, size)
VALUES
(1, 1, 'Smile', 'zadolbysh', 15),
(2, 2, 'Smile', 'nadoelbysh', 15),
(3, 3, 'Smile', 'ustalbysh', 15),
(4, 4, 'Smile', 'otpuskby', 15),
(5, 5, 'Smile', 'moreby', 15),
(6, 6, 'Smile', 'pesokby', 15);
*/
SELECT * FROM media;

DROP TABLE IF EXISTS likes;
CREATE TABLE likes( -- создали группу лайков
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

INSERT INTO likes (user_id, media_id)
VALUE (1, 2), (1, 3), (2, 1), (3, 3), (3, 1), (3, 4), (4, 2), 
(5, 1), (5, 2), (6, 3), (6, 4), (7, 1), (8, 2), (9, 1), (10, 2), (3, 5);



ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);
