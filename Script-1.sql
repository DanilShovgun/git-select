CREATE TABLE artist(
  id SERIAL PRIMARY KEY,
  name VARCHAR
);

CREATE TABLE if not exists genre(
  id SERIAL PRIMARY KEY,
  name VARCHAR(30) not null  
);

CREATE table if not exists artist_genre (
  id SERIAL PRIMARY KEY,
  artist_id INT REFERENCES artist(id),
  genre_id INT REFERENCES genre(id)
);

CREATE table if not exists album(
  id SERIAL PRIMARY KEY,
  title VARCHAR
);

CREATE table if not exists album_artist(
  id SERIAL PRIMARY KEY,
  album_id INT REFERENCES album(id),
  artist_id INT REFERENCES artist(id)
);

CREATE table if not exists track(
  id SERIAL PRIMARY KEY,
  title VARCHAR(30) not null,
  album_id INT REFERENCES album(id),
  duration VARCHAR(30) not null
);

CREATE table if not exists mix(
  id SERIAL PRIMARY KEY,
  title VARCHAR(30) not null,
  year INT
);

CREATE table if not exists mix_track(
  id SERIAL PRIMARY KEY,
  mix_id INT REFERENCES mix(id),
  track_id INT REFERENCES track(id)
);

INSERT INTO artist (name) VALUES 
('Kendrick Lamar'),
('Taylor Swift'),
('Drake'),
('Ariana Grande'),
('Billie Eilish'),
('Lizzo'),
('Post Malone'),
('Beyonce');

INSERT INTO genre (name) VALUES 
('Pop'),
('Hip Hop'),
('R&B'),
('Rock'),
('Electronic');

INSERT INTO artist_genre (artist_id, genre_id) VALUES 
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(3, 2),
(3, 3),
(4, 1),
(4, 3),
(5, 1),
(5, 2),
(6, 3),
(7, 2),
(7, 4),
(8, 1),
(8, 3);

INSERT INTO album (title) VALUES 
('good kid, m.A.A.d city'),
('1989'),
('Scorpion'),
('thank u, next'),
('When We All Fall Asleep, Where Do We Go?'),
('Cuz I Love You'),
('Hollywood''s Bleeding'),
('The Lion King: The Gift');

INSERT INTO album_artist (album_id, artist_id) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);

INSERT INTO track (title, album_id, duration) VALUES 
('Bitch, Don', 1, '5:10'),
('Shake It Off', 2, '3:39'),
('God''s Plan', 3, '3:18'),
('7 rings', 4, '3:28'),
('bad guy', 5, '3:14'),
('Truth Hurts', 6, '2:53'),
('Circles', 7, '3:35'),
('Brown Skin', 8, '4:09'),
('m.A.A.d city', 1, '5:50'),
('Blank Space', 2, '3:51'),
('Nonstop', 3, '5:16'),
('needy', 4, '2:51'),
('bury a friend', 5, '3:13'),
('Good as Hell', 6, '3:00'),
('Enemies', 7, '3:16'),
('Mood 4 Eva', 8, '4:31'),
('Sing About Me', 1, '12:05'),
('Welcome To', 2, '3:32'),
('Elevate', 3, '3:04'),
('NASA', 4, '3:02'),
('xanny', 5, '4:03'),
('Water Me', 6, '3:26'),
('On The Road', 7, '3:38'),
('Find Your', 8, '2:42');

INSERT INTO mix (title, year) VALUES 
('Summer Hits 2020', 2020),
('Hip Hop Classics', 2015),
('Power Ballads', 2000),
('EDM Bangers', 2019),
('Chill Vibes', 2020),
('Throwback Essentials', 2021),
('Late Night Jams', 2018),
('Pump Up Anthems', 2016);

INSERT INTO mix_track (mix_id, track_id) VALUES 
(1, 2),
(1, 4),
(1, 6),
(1, 7),
(2, 1),
(2, 3),
(2, 6),
(3, 8),
(3, 11),
(3, 12),
(3, 15),
(3, 18),
(3, 21),
(3, 22),
(7, 13),
(7, 15),
(7, 16),
(7, 19),
(8, 14),
(8, 17),
(8, 21),
(8, 23);

ALTER TABLE album
ADD COLUMN release_date DATE;

ALTER TABLE track
ALTER COLUMN duration TYPE TIME USING (duration::TIME);

UPDATE album
SET release_date = CASE title
    WHEN 'good kid, m.A.A.d city' THEN '2012-10-22'::DATE
    WHEN '1989' THEN '2014-10-27'::DATE
    WHEN 'Scorpion' THEN '2018-06-29'::DATE
    WHEN 'thank u, next' THEN '2019-02-08'::DATE
    WHEN 'When We All Fall Asleep, Where Do We Go?' THEN '2019-03-29'::DATE
    WHEN 'Cuz I Love You' THEN '2019-04-19'::DATE
    WHEN 'Hollywood''s Bleeding' THEN '2019-09-06'::DATE
    WHEN 'The Lion King: The Gift' THEN '2019-07-19'::DATE
  END;

SELECT genre.name, COUNT(artist_genre.artist_id) as artist_count 
FROM genre 
JOIN artist_genre ON genre.id = artist_genre.genre_id 
GROUP BY genre.name;

SELECT COUNT(track.id) as tracks_count 
FROM track 
JOIN album ON track.album_id = album.id 
WHERE album.release_date BETWEEN '2019-01-01' AND '2020-12-31';

SELECT album.title, AVG(track.duration) as avg_duration 
FROM album 
JOIN track ON album.id = track.album_id 
GROUP BY album.title;

SELECT artist.name 
FROM artist 
LEFT JOIN album_artist ON artist.id = album_artist.artist_id 
LEFT JOIN album ON album_artist.album_id = album.id 
WHERE album.release_date NOT BETWEEN '2020-01-01' AND '2020-12-31' OR album.release_date IS NULL;

SELECT mix.title 
FROM mix 
JOIN mix_track ON mix.id = mix_track.mix_id 
JOIN track ON mix_track.track_id = track.id 
JOIN album ON track.album_id = album.id 
JOIN album_artist ON album.id = album_artist.album_id 
JOIN artist ON album_artist.artist_id = artist.id 
WHERE artist.name = 'Taylor Swift';

SELECT album.title 
FROM album 
JOIN album_artist ON album.id = album_artist.album_id 
JOIN artist ON album_artist.artist_id = artist.id 
JOIN artist_genre ON artist.id = artist_genre.artist_id 
GROUP BY album.title 
HAVING COUNT(DISTINCT artist_genre.genre_id) > 1;

SELECT track.title 
FROM track 
LEFT JOIN mix_track ON track.id = mix_track.track_id 
WHERE mix_track.track_id IS NULL;

SELECT artist.name 
FROM artist 
JOIN album_artist ON artist.id = album_artist.artist_id 
JOIN track ON album_artist.album_id = track.album_id 
WHERE track.duration = (SELECT MIN(duration) FROM track);

SELECT album.title 
FROM album 
JOIN (SELECT album_id, COUNT(id) as track_count FROM track GROUP BY album_id) as track_counts 
ON album.id = track_counts.album_id 
WHERE track_counts.track_count = (SELECT MIN(track_count) FROM (SELECT COUNT(id) as track_count FROM track GROUP BY album_id) as counts);





