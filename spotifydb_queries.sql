-- Spotify DB

-- creating the table

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA

SELECT COUNT(*)FROM spotify;

SELECT COUNT (DISTINCT album) FROM spotify;

SELECT COUNT (DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

-- checking and deleting songs with zero duration
SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

---------
-- Easy
---------

--Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * 
FROM spotify
WHERE stream > 100000000;

--List all albums along with their respective artists.

SELECT 
	DISTINCT album, artist
FROM spotify;

--Get the total number of comments for tracks where licensed = TRUE.

SELECT 
	SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'true';

--Find all tracks that belong to the album type single.

SELECT *
FROM spotify 
WHERE album_type = 'single';

--Count the total number of tracks by each artist.

SELECT 
	artist,
	COUNT(*) as total_no_songs
FROM spotify
GROUP BY artist;

----------
-- Medium
----------

-- Calculate the average danceability of tracks in each album.

SELECT 
	album,
	AVG(danceability) as avg_danceability 
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;

-- Find the top 5 tracks with the highest energy values.

SELECT 
	track,
	MAX(energy) AS Top5HighEnergySongs
FROM spotify
GROUP BY track
ORDER BY Top5HighEnergySongs DESC 
LIMIT 5;

-- List all tracks along with their views and likes where official_video = TRUE.
-- Which official video tracks have the highest total likes, and what are their total views and likes?

SELECT 
	track,
	SUM(views) AS total_views,
	SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY track
ORDER BY total_likes DESC;

-- For each album, calculate the total views of all associated tracks.

SELECT 
	album,
	track,
	SUM(views) AS total_views
FROM spotify
GROUP BY album, track 
ORDER By total_views DESC;

-- Retrieve the tracks that have been streamed on Spotify more than YouTube.

-- Using Sub-Query
SELECT * FROM
(SELECT
	track,
	COALESCE (SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
	COALESCE (SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY track
) as t1
WHERE 
	streamed_on_spotify > streamed_on_youtube AND streamed_on_youtube <> 0

-- Write a query to find tracks where the liveness score is above the average.

SELECT 
	track,
	liveness
FROM spotify 
WHERE liveness > (SELECT AVG(liveness) FROM spotify)

-----------
-- Advanced 
-----------

-- Find the top 3 most-viewed tracks for each artist using window functions.

SELECT * 
FROM(
	SELECT
		artist,
		track,
		views,
		DENSE_RANK() OVER (PARTITION BY artist ORDER BY views DESC) as views_rank
	FROM spotify
) as ranked
WHERE views_rank <= 3;

-- Using CTE  

WITH ranked AS (
    SELECT
        artist,
        track,
        views,
        DENSE_RANK() OVER (PARTITION BY artist ORDER BY views DESC) AS views_rank
    FROM spotify
)
SELECT *
FROM ranked
WHERE views_rank <= 3;

-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH energy AS (
	SELECT 
		album,
		MAX(energy) as HighestEnergy, 
		MIN(energy) as LowestEnergy
	FROM spotify
	GROUP BY album
)
SELECT
	album,
	HighestEnergy - LowestEnergy AS EnergyDifference
FROM energy
ORDER BY EnergyDifference DESC;

-- Query Optimization using Index 

EXPLAIN ANALYZE 
SELECT
	artist,
	track,
	views
FROM spotify
WHERE artist = 'Coldplay' AND most_played_on = 'Youtube'
ORDER BY stream DESC LIMIT 2

CREATE INDEX artist_index ON spotify_tracks(artist);

DROP INDEX artist_index;
