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
-- DELETE FROM users WHERE id = 2;
-- SELECT * FROM users;

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
-- DELETE FROM profiles WHERE user_id = 2;
-- SELECT * FROM profiles;

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
    FOREIGN KEY (initiator_user_id) REFERENCES users(id) FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id) FOREIGN KEY (media_id) REFERENCES media(id)
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
-- DELETE FROM friend_requests WHERE initiator_user_id = 2;
-- DELETE FROM friend_requests WHERE target_user_id = 2;
-- SELECT * FROM friend_requests;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO messages  (from_user_id, to_user_id, body, created_at) VALUES
(1, 2, 'Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.',  DATE_ADD(NOW(), INTERVAL 1 MINUTE)),
(2, 1, 'Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.',  DATE_ADD(NOW(), INTERVAL 3 MINUTE)),
(3, 1, 'Sed mollitia quo sequi nisi est tenetur at rerum. Sed quibusdam illo ea facilis nemo sequi. Et tempora repudiandae saepe quo.',  DATE_ADD(NOW(), INTERVAL 5 MINUTE)),
(4, 1, 'Quod dicta omnis placeat id et officiis et. Beatae enim aut aliquid neque occaecati odit. Facere eum distinctio assumenda omnis est delectus magnam.',  DATE_ADD(NOW(), INTERVAL 11 MINUTE)),
(1, 5, 'Voluptas omnis enim quia porro debitis facilis eaque ut. Id inventore non corrupti doloremque consequuntur. Molestiae molestiae deleniti exercitationem sunt qui ea accusamus deserunt.',  DATE_ADD(NOW(), INTERVAL 12 MINUTE)),
(1, 6, 'Rerum labore culpa et laboriosam eum totam. Quidem pariatur sit alias. Atque doloribus ratione eum rem dolor vitae saepe.',  DATE_ADD(NOW(), INTERVAL 14 MINUTE)),
(1, 7, 'Perspiciatis temporibus doloribus debitis. Et inventore labore eos modi. Quo temporibus corporis minus. Accusamus aspernatur nihil nobis placeat molestiae et commodi eaque.',  DATE_ADD(NOW(), INTERVAL 15 MINUTE)),
(8, 1, 'Suscipit dolore voluptas et sit vero et sint. Rem ut ratione voluptatum assumenda nesciunt ea. Quas qui qui atque ut. Similique et praesentium non voluptate iure. Eum aperiam officia quia dolorem.',  DATE_ADD(NOW(), INTERVAL 21 MINUTE)),
(9, 3, 'Et quia libero aut vitae minus. Rerum a blanditiis debitis sit nam. Veniam quasi aut autem ratione dolorem. Sunt quo similique dolorem odit totam sint sed.',  DATE_ADD(NOW(), INTERVAL 22 MINUTE)),
(10, 2, 'Praesentium molestias quia aut odio. Est quis eius ut animi optio molestiae. Amet tempore sequi blanditiis in est.',  DATE_ADD(NOW(), INTERVAL 25 MINUTE)),
(8, 3, 'Molestiae laudantium quibusdam porro est alias placeat assumenda. Ut consequatur rerum officiis exercitationem eveniet. Qui eum maxime sed in.',  DATE_ADD(NOW(), INTERVAL 27 MINUTE)),
(8, 1, 'Quo asperiores et id veritatis placeat. Aperiam ut sit exercitationem iste vel nisi fugit quia. Suscipit labore error ducimus quaerat distinctio quae quasi.',  DATE_ADD(NOW(), INTERVAL 28 MINUTE)),
(8, 1, 'Earum sunt quia sed harum modi accusamus. Quia dolor laboriosam asperiores aliquam quia. Sint id quasi et cumque qui minima ut quo. Autem sed laudantium officiis sit sit.',  DATE_ADD(NOW(), INTERVAL 33 MINUTE)),
(4, 1, 'Aut enim sint voluptas saepe. Ut tenetur quos rem earum sint inventore fugiat. Eaque recusandae similique earum laborum.',  DATE_ADD(NOW(), INTERVAL 35 MINUTE)),
(4, 1, 'Nisi rerum officiis officiis aut ad voluptates autem. Dolor nesciunt eum qui eos dignissimos culpa iste. Atque qui vitae quos odit inventore eum. Quam et voluptas quia amet.',  DATE_ADD(NOW(), INTERVAL 35 MINUTE)),
(4, 1, 'Consequatur ut et repellat non voluptatem nihil veritatis. Vel deleniti omnis et consequuntur. Et doloribus reprehenderit sed earum quas velit labore.',  DATE_ADD(NOW(), INTERVAL 37 MINUTE)),
(2, 1, 'Iste deserunt in et et. Corrupti rerum a veritatis harum. Ratione consequatur est ut deserunt dolores.',  DATE_ADD(NOW(), INTERVAL 37 MINUTE)),
(8, 1, 'Dicta non inventore autem incidunt accusamus amet distinctio. Aut laborum nam ab maxime. Maxime minima blanditiis et neque. Et laboriosam qui at deserunt magnam.',  DATE_ADD(NOW(), INTERVAL 41 MINUTE)),
(8, 1, 'Amet ad dolorum distinctio excepturi possimus quia. Adipisci veniam porro ipsum ipsum tempora est blanditiis. Magni ut quia eius qui.',  DATE_ADD(NOW(), INTERVAL 42 MINUTE)),
(8, 1, 'Porro aperiam voluptate quo eos nobis. Qui blanditiis cum id eos. Est sit reprehenderit consequatur eum corporis. Molestias quia quo sit architecto aut.',  DATE_ADD(NOW(), INTERVAL 50 MINUTE));

SELECT * FROM messages;
-- DELETE FROM messages WHERE from_user_id = 2;
-- DELETE FROM messages WHERE to_user_id = 2;
-- SELECT * FROM messages; 

DROP TABLE IF EXISTS likes;
CREATE TABLE likes( -- создали группу лайков
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id)
/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

INSERT INTO likes (user_id, media_id)
VALUE (1, 2), (1, 3), (2, 1), (3, 3), (3, 1), (3, 4), (4, 2), 
(5, 1), (5, 2), (6, 3), (6, 4), (7, 1), (8, 2), (9, 1), (10, 2), (3, 5);

SELECT * FROM likes;
-- DELETE FROM likes WHERE user_id = 2;
-- SELECT * FROM likes;

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types( -- создали группу типы медиа
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO media_types(name)
VALUES ('smaile1'), ('smaile2'), ('smaile3'), ('smaile4'), ('smaile5'), ('smaile6');

SELECT * FROM media_types;

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

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

INSERT INTO media(media_type_id, user_id, body, filename, size)
VALUES
(1, 1, 'Smile', 'zadolbysh', 15),
(2, 2, 'Smile', 'nadoelbysh', 15),
(3, 3, 'Smile', 'ustalbysh', 15),
(4, 4, 'Smile', 'otpuskby', 15),
(5, 5, 'Smile', 'moreby', 15),
(6, 6, 'Smile', 'pesokby', 15);

SELECT * FROM media;
-- DELETE FROM media WHERE user_id = 2;
-- SELECT * FROM media;

/*
Домашнее задание 5
*/

/*
Задача 1: 
Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. 
Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. 
Функция должна возвращать номер пользователя.
*/

SELECT * FROM profiles;
SELECT * FROM friend_requests;
SELECT * FROM messages;
SELECT * FROM likes;
SELECT * FROM media;
SELECT * FROM users;

DROP FUNCTION IF EXISTS delete_user;
DELIMITER //
CREATE FUNCTION delete_user (user_to_delete int)
RETURNS INT DETERMINISTIC
BEGIN	
	DELETE FROM profiles
    WHERE user_id = user_to_delete;
	DELETE FROM media
    WHERE user_id = user_to_delete;
	DELETE FROM messages
    WHERE from_user_id = user_to_delete;
    DELETE FROM likes
    WHERE user_id = user_to_delete;
	DELETE FROM friend_requests
	WHERE  user_to_delete = initiator_user_id OR user_to_delete = target_user_id;
	DELETE FROM users
	WHERE id = user_to_delete;
    RETURN user_to_delete;
END//
DELIMITER ;

SELECT delete_user(3);

/*
Задание 2: Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.
*/

DROP PROCEDURE IF EXISTS deleting_user;
DELIMITER //

CREATE PROCEDURE deleting_user (user_to_delete int)
BEGIN
  START TRANSACTION;
	DELETE FROM profiles
    WHERE user_id = user_to_delete;
	DELETE FROM media
    WHERE user_id = user_to_delete;
	DELETE FROM messages
    WHERE from_user_id = user_to_delete;
    DELETE FROM likes
    WHERE user_id = user_to_delete;
	DELETE FROM friend_requests
	WHERE  user_to_delete = initiator_user_id OR user_to_delete = target_user_id;
	DELETE FROM users
	WHERE id = user_to_delete;
	  
COMMIT;
END //
DELIMITER ;

CALL deleting_user(5);

