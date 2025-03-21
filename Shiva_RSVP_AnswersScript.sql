-- RSVP SQL Assignment
-- Submitted by Shiva Shankar Iyer (March 2025)

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    'director_mapping' as Column_name, COUNT(*) as Count_of_Rows
FROM
    director_mapping 
UNION ALL SELECT 
    'genre' as Column_name, COUNT(*) as Count_of_Rows
FROM
    genre 
UNION ALL SELECT 
    'movie' as Column_name, COUNT(*) as Count_of_Rows
FROM
    movie 
UNION ALL SELECT 
    'names' as Column_name, COUNT(*) as Count_of_Rows
FROM
    names 
UNION ALL SELECT 
    'ratings' as Column_name, COUNT(*) as Count_of_Rows
FROM
    ratings 
UNION ALL SELECT 
    'role_mapping' as Column_name, COUNT(*) as Count_of_Rows
FROM
    role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:


SELECT
	SUM(CASE WHEN title is NULL THEN 1 ELSE 0 END) as title_null,
    SUM(CASE WHEN year is NULL THEN 1 ELSE 0 END) as year_null,
    SUM(CASE WHEN date_published is NULL THEN 1 ELSE 0 END) as date_published_null,
    SUM(CASE WHEN duration is NULL THEN 1 ELSE 0 END) as duration_null,
    SUM(CASE WHEN country is NULL THEN 1 ELSE 0 END) as country_null,
    SUM(CASE WHEN worlwide_gross_income is NULL THEN 1 ELSE 0 END) as worldwide_gross_income_null,
    SUM(CASE WHEN languages is NULL THEN 1 ELSE 0 END) as languages_null,
    SUM(CASE WHEN production_company is NULL THEN 1 ELSE 0 END) as production_company_null
    from movie;
    
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- PART 1
select year as Year, count(id) as number_of_movies
from movie
GROUP BY Year;

/*The year 2017 had the most releases, while 2019 had the least number of releases.*/

-- PART 2
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie	
GROUP BY month_num
ORDER BY month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(id) as number_of_movies, year
from movie
where (country LIKE '%USA%' or country LIKE '%INDIA') and year = '2019'
GROUP BY year;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select DISTINCT genre from genre;
select count(distinct genre) from genre; -- numbet of unique genres

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH movie_summary as (
SELECT 
    genre, COUNT(id) AS No_of_movies
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY genre
ORDER BY No_of_movies DESC
LIMIT 1
)

select * from movie_summary;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH unique_genres as (
select movie_id,
count(genre) as Total_genres
from genre
group by movie_id
)

select count(*) as unique_movie_genres
from unique_genres
where Total_genres = 1;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, ROUND(AVG(m.duration),2) AS avg_duration
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY g.genre;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH movie_rank as (
select g.genre,
count(m.id) as movie_count,
RANK() over (PARTITION BY g.genre ORDER BY COUNT(m.id) DESC) as genre_rank
from genre g
inner join
movie m
on g.movie_id = m.id
group by g.genre
)

select * from movie_rank
where genre = 'Thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

  /* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH ratings_rank as (
select m.title, r.avg_rating, 
ROW_NUMBER() over (ORDER BY avg_rating DESC) as movie_rank
from movie m
inner join
ratings r
on m.id = r.movie_id 
)

select * from ratings_rank
where movie_rank <=10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    r.median_rating, COUNT(m.id) AS movie_count
FROM
    ratings r
        INNER JOIN
    movie m ON m.id = r.movie_id
GROUP BY r.median_rating
ORDER BY movie_count DESC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with production_company_hit as (
select m.production_company, count(m.id) as movie_count,
RANK() OVER (ORDER BY count(m.id) DESC) as prod_company_rank
from movie m
inner join
ratings r
on m.id = r.movie_id
where
avg_rating > 8
and production_company is NOT NULL
group by 
production_company)

select * from production_company_hit
where prod_company_rank=1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre, count(id) as movie_count
from movie m
inner join
genre g 
on g.movie_id = m.id
inner join
ratings r
on r.movie_id = m.id
where
	MONTH(date_published) = 3
    and YEAR(date_published) = 2017
    and country LIKE '%USA%'
group by g.genre
order by 
count(m.id) desc;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- For Average rating
select m.title, r.avg_rating, g.genre
from movie m
inner join
genre g
on m.id = g.movie_id
inner join
ratings r 
on m.id = r.movie_id
where 
m.title LIKE 'The%' and r.avg_rating > 8
ORDER BY r.avg_rating DESC;

-- For Median rating

select m.title, r.median_rating, g.genre
from movie m
inner join
genre g
on m.id = g.movie_id
inner join
ratings r 
on m.id = r.movie_id
where 
m.title LIKE 'The%' and r.median_rating > 8
ORDER BY r.median_rating DESC;

/* There is a change in the output with respect to median rating.
-- The highest average rating was 9.5, while the highest median rating is 10.
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    m.title AS April_2018_2019_releases,
    r.median_rating AS median_rating
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    (m.date_published BETWEEN '2018-04-01' AND '2019-04-01')
        AND r.median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    m.country AS Country,
    SUM(r.total_votes) AS Total_cumulative_votes
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    m.country IN ('Germany' , 'Italy')
        AND m.country IS NOT NULL
GROUP BY m.country;

-- Answer is Yes
-- If the question is answered with the 'Languages' field (German/Italian) instead of 'Country', the output will be different.

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/
-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
SUM(CASE WHEN id is NULL THEN 1 ELSE 0 END) as id_null_count,
SUM(CASE WHEN name is NULL THEN 1 ELSE 0 END) as name_nulls,
SUM(CASE WHEN height is NULL THEN 1 ELSE 0 END) as height_nulls,
SUM(CASE WHEN date_of_birth is NULL THEN 1 ELSE 0 END) as date_of_birth_nulls,
SUM(CASE WHEN known_for_movies is NULL THEN 1 ELSE 0 END) as known_for_movies_nulls
from names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* Finding the top 3 genres with highest rated movies*/

WITH Top_3_genre as (
select g.genre, count(m.id) as Number_of_movies
from movie m
inner join
genre g 
on m.id = g.movie_id
inner join
ratings r
on r.movie_id = m.id
where
r.avg_rating > 8
group by g.genre
order by Number_of_movies desc
LIMIT 3
)
 -- select * from Top_3_genre;

/* Now, we find the Top 3 directors from the Top 3 genres*/

SELECT 
    n.name AS director_Name, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    director_mapping dm ON dm.movie_id = m.id
        INNER JOIN
    names n ON dm.name_id = n.id
        INNER JOIN
    genre g ON g.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
    WHERE
    g.genre IN (SELECT 
            genre
        FROM
            Top_3_genre)
        AND r.avg_rating > 8
GROUP BY director_name	
ORDER BY movie_count DESC
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    n.name AS actor_name, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
        INNER JOIN
    role_mapping rm ON rm.movie_id = m.id
        INNER JOIN
    names n ON rm.name_id = n.id
WHERE
    r.median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, SUM(r.total_votes) as vote_count,
ROW_NUMBER() OVER (ORDER BY SUM(r.total_votes) DESC) as prod_vote_rank
from movie m
inner join
ratings r
on m.id = r.movie_id
group by m.production_company
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select 
n.name as actor_name, 
SUM(r.total_votes) as total_votes,
count(m.id) as movie_count,
ROUND((SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)),2) as actor_avg_rating,
ROW_NUMBER() over (ORDER BY ROUND((SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)),2) DESC) as actor_rank
from movie m
inner join
ratings r
on m.id = r.movie_id
inner join
role_mapping rm
on m.id = rm.movie_id
inner join
names n
on rm.name_id = n.id
where
m.country LIKE '%INDIA'
and rm.category = 'actor'
group by actor_name
having movie_count >=5;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select 
n.name as actress_name, SUM(r.total_votes) as total_votes,
count(m.id) as movie_count,
ROUND((SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)),2) as actress_avg_rating,
ROW_NUMBER() OVER (ORDER BY ROUND((SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes)),2) DESC) as actress_rank
from movie m
inner join
ratings r 
on m.id = r.movie_id
inner join
role_mapping rm
on m.id = rm.movie_id
inner join
names n
on n.id = rm.name_id
where
rm.category = 'actress'
and m.country LIKE '%INDIA'
and m.languages LIKE '%hindi'
group by actress_name
having movie_count >=3
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
select m.title as movie_name, r.avg_rating as avg_rating, 
CASE
when r.avg_rating > 8 then 'Superhit'
when r.avg_rating BETWEEN 7 and 8 then 'Hit'
when r.avg_rating BETWEEN 5 and 7 then 'One-time-watch'
ELSE
	'FLOP'
END AS 
	'rating_category'
from movie m
inner join
ratings r
on m.id = r.movie_id
inner join
genre g 
on g.movie_id = r.movie_id
where 
g.genre = 'Thriller' and r.total_votes >=25000
order by r.avg_rating desc;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select g.genre, ROUND(AVG(m.duration),2) as avg_duration,
SUM(ROUND(AVG(m.duration),2)) over (order by g.genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total_duration,
ROUND(AVG(ROUND(AVG(m.duration),2)) over (order by g.genre ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW),2) as moving_avg_duration 
-- To round the average duration to 2 decimal places, the whole expression is locked into the ROUND() function.
from movie m
inner join
genre g
on g.movie_id = m.id
group by 
g.genre
order by 
g.genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Converting all the values for worldwide_gross_income in US$ for easier analysis

/*First, we find the Top 3 genres with the most number of movies*/

with genre_summary as
(
select g.genre, count(m.id) as movie_count
from genre g
left join movie m on g.movie_id = m.id
group by g.genre
order by movie_count desc
LIMIT 3
),

 -- select * from genre_summary; 
 -- The Top 3 genres are Drama, Comedy and Thriller.

-- Taking the coversion rate for INR to USD as $1 = Rs.80
worldwide_gross_collection as 
(
select id as movie_id,
CASE
	when LOCATE('INR',worlwide_gross_income) THEN RIGHT (worlwide_gross_income, LENGTH(worlwide_gross_income)-4)/80
    when LOCATE('$',worlwide_gross_income) THEN RIGHT (worlwide_gross_income, LENGTH(worlwide_gross_income)-2)
ELSE
	worlwide_gross_income
END AS 'worlwide_gross_income'
from 
movie 
),

movie_summary as
(
select g.genre as genre,
m.id as movie_id,
m.year as year,
m.title as movie_name,
m.worlwide_gross_income as worldwide_gross_income,
ROW_NUMBER() OVER (PARTITION BY m.year ORDER BY gc.worlwide_gross_income desc) as movie_rank
from movie m
left join 
genre g on m.id = g.movie_id
left join
worldwide_gross_collection gc on m.id = gc.movie_id
where g.genre in (select genre from genre_summary)
)

select * from movie_summary mvs
where mvs.movie_rank <=5;
    
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_Top_2 as (
select m.production_company,
count(id) as movie_count,
ROW_NUMBER() over (ORDER BY count(id) desc) as prod_comp_rank
from movie m
inner join
ratings r
on m.id = r.movie_id
where
r.median_rating>=8
and POSITION(',' in m.languages) > 0 -- selecting movies in multiple languages
and m.production_company is not NULL
group by m.production_company
)

select 
production_company,
movie_count,
prod_comp_rank
from production_Top_2
where 
prod_comp_rank <=2; -- Since we only need the Top 2 Production companies producing multilingual cinema.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?
-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH Top_3_actress AS
(
select n.name AS actress_name,
SUM(total_votes) as total_votes, -- the total votes acts as the tie-breaker
count(r.movie_id) as movie_count,
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating
from movie m
inner join 
ratings r
on m.id=r.movie_id
inner join
role_mapping rm
on m.id = rm.movie_id
inner join
names n
on rm.name_id = n.id
inner join
genre g
on g.movie_id = m.id
where 
r.avg_rating > 8 
and rm.category LIKE 'actress'
and genre LIKE 'Drama'
group by actress_name
)

select *,
ROW_NUMBER() over (ORDER BY movie_count desc) as actress_rank
from Top_3_actress
LIMIT 3;
          
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with director_next_movie_date as (
select dm.name_id,
n.name,
dm.movie_id,
m.duration,
r.avg_rating,
r.total_votes,
m.date_published,
LEAD(m.date_published,1) over (partition by dm.name_id order by m.date_published, movie_id) as next_movie_date -- provides the next movie date of the director
from director_mapping dm
inner join
names n
on n.id = dm.name_id
inner join 
movie m
on m.id = dm.movie_id
inner join
ratings r 
on r.movie_id = m.id
),

top_9_director as 
(select *, DATEDIFF(next_movie_date, date_published) as date_difference from director_next_movie_date)

select name_id as director_id,
name as director_name,
count(movie_id) as number_of_movies,
ROUND(AVG(date_difference),2) as avg_inter_movie_days,
ROUND(AVG(avg_rating),2) as avg_rating,
SUM(total_votes) as total_votes,
MIN(avg_rating) as min_rating,
MAX(avg_rating) as max_rating,
SUM(duration) as total_duration
from top_9_director
group by director_id
order by count(movie_id) DESC
LIMIT 9; -- selecting the top 9 directors from the list







