-- ADVANCED SQL PROJECT--


-- SPOTIFY ANALYSIS PROJECT --


-- create table

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

SELECT * FROM spotify


-- EDA ( EXPLORATORY DATA ANALYSIS )


select count(*) from spotify;

select count(DISTINCT artist) from spotify;

select DISTINCT album_type from spotify;

select MAX(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify
where duration_min = 0

delete from spotify
where duration_min = 0

select DISTINCT channel from spotify;

select DISTINCT most_played_on from spotify;


-- Easy Level


-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

select track,stream
from spotify
where stream > '1000000000'


-- 2. List all albums along with their respective artists.

select distinct album,artist
from spotify


-- 3. Get the total number of comments for tracks where licensed = TRUE.

select sum(comments) as total_count
from spotify
where licensed = 'TRUE'


-- 4. Find all tracks that belong to the album type single.

select track,album_type
from spotify
where album_type = 'single'

-- 5. Count the total number of tracks by each artist.

select artist,count(track) as track_count
from spotify
group by 1
order by 2 desc



-- Medium Level



-- 1. Calculate the average danceability of tracks in each album.

select album,avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc


-- 2. Find the top 5 tracks with the highest energy values.

select track,max(energy) as high_energy
from spotify
group by 1
order by 2 desc
limit 5


-- 3. List all tracks along with their views and likes where official_video = TRUE.

select track,sum(views) as total_views,sum(likes) as total_likes
from spotify
where official_video = 'True'
group by 1
order by 2 desc,3 desc


-- 4. For each album, calculate the total views of all associated tracks.

select album,track,sum(views) as total_views
from spotify
group by 1,2
order by 3 desc

-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

with my_cte as (
select track,
sum(case when most_played_on = 'Youtube' then stream else 0 end) as youtube_count,
sum(case when most_played_on = 'Spotify' then stream else 0 end) as Spotify_count
from spotify
group by 1
)
select * from my_cte
where spotify_count>youtube_count and youtube_count <> 0

----

with my_cte as (
select track,
coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as youtube_count,
coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as Spotify_count
from spotify
group by 1
)
select * from my_cte
where spotify_count>youtube_count and youtube_count <> 0

---- 

select  * from
(select track,
coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as youtube_count,
coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as Spotify_count
from spotify
group by 1) as t1
where spotify_count>youtube_count and youtube_count <> 0



-- Advanced Level


-- 1. Find the top 3 most-viewed tracks for each artist using window functions.

with my_cte as (
select artist,track,sum(views) as total_views,rank() over(partition by artist order by sum(views) desc) as rankk
from spotify
group by 1,2
)
select artist,track,total_views,rankk
from my_cte
where rankk <= 3
order by 1,4



-- 2. Write a query to find tracks where the liveness score is above the average.

select track,liveness
from spotify
where liveness > (select avg(liveness) from spotify)
order by 2 desc


-- 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with my_cte as(
select album,max(energy) as max_energy,min(energy) as min_energy
from spotify
group by 1
)
select album,max_energy - min_energy as energy_difference
from my_cte
order by energy_difference desc

