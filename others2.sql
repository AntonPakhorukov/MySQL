USE seminars;

CREATE TABLE movies
(id Int NOT NULL PRIMARY KEY AUTO_INCREMENT,
movie_name VARCHAR(100) NOT NULL,
movie_year Int NOT NULL,
movie_time Int NOT NULL,
genre Int NOT NULL,
comment VARCHAR(2000) NOT NULL);

CREATE TABLE genres
(id Int NOT NULL PRIMARY KEY AUTO_INCREMENT,
genre VARCHAR(25) NOT NULL);

DROP TABLE genres;

ALTER TABLE movies
ADD CONSTRAINT fk_genre FOREIGN KEY(genre) REFERENCES genres(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

INSERT INTO genres(genre)
VALUES ('fantastic'),('comedy'),('thriller'),('fantasy'),('drama');

SELECT * FROM genres;

SELECT * FROM movies;

INSERT INTO movies(genre, movie_name, movie_year, movie_time, comment)
VALUES 
(4, 'Harry Potter and the Philosophers Stone', 2001, 152, "An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself, his family and the terrible evil that haunts the magical world."),
(4, 'Harry Potter and the Chamber of Secrets', 2002, 162,"An ancient prophecy seems to be coming true when a mysterious presence begins stalking the corridors of a school of magic and leaving its victims paralyzed."),
(5, 'The Green Mile', 1999, 188,'Death Row guards at a penitentiary, in the 1930s, have a moral dilemma with their job when they discover one of their prisoners, a convicted murderer, has a special gift.'),
(5, 'Forrest Gump', 1994, 142,"The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and other historical events unfold from the perspective of an Alabama man with an IQ of 75, whose only desire is to be reunited with his childhood sweetheart.");

SELECT * FROM movies;
