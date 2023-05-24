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

SELECT * FROM profiles;

-- ДОМАШНЕЕ ЗАДАНИЕ:

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
CREATE TABLE communities( -- создали таблицу групп
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities( -- создали таблицу участников группы
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

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

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);
