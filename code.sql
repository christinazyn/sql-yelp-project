-- Appendix 2. SQLite Code

-- total distinct user count
SELECT COUNT(DISTINCT user_id)
FROM user;

-- total distinct business count
SELECT COUNT(DISTINCT business_id)
FROM business;

-- total distinct review count
SELECT COUNT(DISTINCT review_id)
FROM review;

-- total distinct reviewer count
SELECT COUNT(DISTINCT user_id)
 FROM review;

-- active user count (users who have posted reviews in 2017)
SELECT COUNT(DISTINCT user_id)
FROM review
WHERE substr(date, 1, 4) = '2017';

-- calculate review per business
CREATE TEMPORARY TABLE review_business AS SELECT business_id,
                                                count( * ) AS freq
                                           FROM review
                                          GROUP BY business_id;

SELECT MAX(freq),
      MIN(freq),
      AVG(freq)
 FROM review_business;

-- top five city with the highest number of businesses
SELECT city,
      count( * ) AS cout_of_business
 FROM business
GROUP BY city
ORDER BY cout_of_business DESC
LIMIT 5;

-- how many new user we have each year
SELECT substr(yelping_since, 1, 4) AS year, count(*) AS NumNewUser
FROM user
GROUP BY year;

-- how many reviews we have each year
SELECT substr(date, 1, 4) AS year, count(*) AS NumReview
FROM review
GROUP BY year;

-- presenting the above two in one table
SELECT *
FROM
   (SELECT substr(yelping_since, 1, 4) as year
   FROM user
   UNION
   SELECT substr(date, 1, 4)
   FROM review)
   LEFT JOIN
   (SELECT substr(yelping_since, 1, 4) AS year, count(*) AS NumNewUser
   FROM user
   GROUP BY year) AS T1
   USING ('year')
   LEFT JOIN
   (SELECT substr(date, 1, 4) AS year, count(*) AS NumReview
   FROM review
   GROUP BY year) AS T2
   USING ('year');

-- first review from each user
SELECT *
FROM review
INNER JOIN
   (SELECT user_id, MAX(date) AS first_date
   FROM review
   GROUP BY user_id) AS A
ON review.user_id = A.user_id
AND review.date = A.first_date;

-- first review from each user joining business information
SELECT *
FROM (SELECT *
   FROM review
   INNER JOIN
       (SELECT user_id, MAX(date) AS first_date
        FROM review
        GROUP BY user_id) AS A
   ON review.user_id = A.user_id
   AND review.date = A.first_date)
   LEFT JOIN business USING ("business_id");
  
-- what rating (star) does the first review give? What are the average stars for the business receiving the new comments?
SELECT FR.stars, count(*) AS frequency, ROUND(AVG(business.stars), 2) AS avg_business_stars
FROM (SELECT *
   FROM review
   INNER JOIN
       (SELECT user_id, MAX(date) AS first_date
        FROM review
        GROUP BY user_id) AS A
   ON review.user_id = A.user_id
   AND review.date = A.first_date) AS FR
   LEFT JOIN business USING ("business_id")
GROUP BY FR.stars
ORDER BY FR.stars;

-- which business attracts more new users to leave the first comment?
SELECT FR.business_id, count(*) AS frequency, B.stars, B.categories
FROM (SELECT *
   FROM review
   INNER JOIN
       (SELECT user_id, MAX(date) AS first_date
        FROM review
        GROUP BY user_id) AS A
   ON review.user_id = A.user_id
   AND review.date = A.first_date) AS FR
   LEFT JOIN business AS B USING ("business_id")
GROUP BY FR.business_id
ORDER BY frequency DESC;

-- number of occurrences of some business keyword in the first reviews 
CREATE TEMPORARY TABLE T1 AS SELECT FR.business_id,
                                   count( * ) AS frequency,
                                   B.stars,
                                   B.categories
                              FROM (
                                       SELECT *
                                         FROM review
                                              INNER JOIN
                                              (
                                                  SELECT user_id,
                                                         MAX(date) AS first_date
                                                    FROM review
                                                   GROUP BY user_id
                                              )
                                              AS A ON review.user_id = A.user_id AND
                                                      review.date = A.first_date
                                   )
                                   AS FR
                                   LEFT JOIN
                                   business AS B USING (
                                       business_id
                                   )
                             GROUP BY FR.business_id
                             ORDER BY frequency DESC;

SELECT sum(frequency) AS occur_restaurants
 FROM T1
WHERE categories LIKE '%restaurants%';

SELECT sum(frequency) AS occur_services
 FROM T1
WHERE categories LIKE '%services%';

SELECT sum(frequency) AS occur_bars
 FROM T1
WHERE categories LIKE '%bars%';

SELECT sum(frequency) AS occur_hotels
 FROM T1
WHERE categories LIKE '%hotels%';


-- business category keyword occurrence 
SELECT word, COUNT(*) AS frequency
FROM(WITH split(word, csv) AS
   (
   SELECT
   -- in final WHERE, we filter raw csv (1st row) and terminal ',' (last row)
   '',
   -- here you can SELECT FROM e.g. another table: col_name||',' FROM X
   (SELECT GROUP_CONCAT(categories, ',')
       FROM
       (SELECT FR.business_id, count(*) AS frequency, B.categories
       FROM (SELECT *
               FROM review
               INNER JOIN (SELECT user_id, MAX(date) AS first_date
                           FROM review
                           GROUP BY user_id) AS A
               ON review.user_id = A.user_id AND review.date = A.first_date) AS FR
               LEFT JOIN business AS B USING ("business_id")
               GROUP BY FR.business_id)
   )||',' -- terminate with ',' indicating csv ending
 -- 'recursive query'
 UNION ALL SELECT
   substr(csv, 0, instr(csv, ',')), -- each word contains text up to next ','
   substr(csv, instr(csv, ',') + 1) -- next recursion parses csv after this ','
 FROM split -- recurse
 WHERE csv != '' -- break recursion once no more csv words exist
) SELECT word FROM split
WHERE word!='')
GROUP BY word
ORDER BY frequency DESC;
