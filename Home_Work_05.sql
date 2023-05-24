USE vk;

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

INSERT INTO friend_requests(initiator_user_id, target_user_id, status)
VALUES
(1, 3, 'requested'),
(1, 4, 'approved'),
(5, 2, 'declined'),
(1, 5, 'approved'),
(7, 6, 'unfriended'),
(2, 1, 'requested'),
(6, 7, 'declined'),
(5, 6, 'approved'),
(3, 4, 'approved'),
(6, 8, 'declined'),
(9, 4, 'approved'),
(6, 9, 'declined'),
(8, 9, 'unfriended');

SELECT * FROM friend_requests;

/*
Домашнее заданиеalter
*/

/*
Задание 1: Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW] 
(вывести друзей друзей пользователя с id=1)
*/
SELECT initiator_user_id, target_user_id FROM friend_requests
WHERE status = 'approved';

DROP VIEW Friends;
CREATE VIEW Friends AS
SELECT initiator_user_id, target_user_id FROM friend_requests
WHERE STATUS = 'approved'
AND (initiator_user_id IN(
	SELECT target_user_id FROM friend_requests
	WHERE STATUS = 'approved' AND initiator_user_id = 1
	UNION
	SELECT initiator_user_id FROM friend_requests
	WHERE STATUS = 'approved' AND target_user_id = 1)
OR target_user_id IN(
	SELECT target_user_id FROM friend_requests
	WHERE STATUS = 'approved' AND initiator_user_id = 1
	UNION
	SELECT initiator_user_id FROM friend_requests
	WHERE STATUS = 'approved' AND target_user_id = 1))
AND target_user_id != 1 AND initiator_user_id != 1;


/*
ЗАДАНИЕ 2: Выведите данные, используя написанное представление [SELECT]
*/

SELECT * FROM Friends;

/*
ЗАДАНИЕ 3: Удалите представление [DROP VIEW]
*/

DROP VIEW Friends;
