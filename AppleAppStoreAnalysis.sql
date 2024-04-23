-- Combining 4 spreadsheets into one for more efficient analysis

create table applestore_description_combined AS

select * from appleStore_description1

union all

select * from appleStore_description2

union all

select * from appleStore_description3

union all

select * from appleStore_description4


** Data Analysis - Exploring the Data **

-- Checking the number of unique apps in both tables

Select count(Distinct ID) As UniqueAppIDs
from AppleStore

Select count(Distinct ID) As UniqueAppIDs
from applestore_description_combined

-- Checking for any missing values in key fields

Select count(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is null

Select count(*) as MissingValues
from applestore_description_combined
where app_desc is null

-- Finding out the number of apps per genre

Select prime_genre, count(*) as NumApps
From AppleStore
Group By prime_genre
order by NumApps Desc

-- Getting an overview of the apps ratings 

SELECT min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
From AppleStore

** Data Analysis - Finding Insights **

-- Determining whether paid apps have higher ratings than free apps

select CASE
	when price > 0 then 'Paid'
    else 'Free'
    end as app_type,
    avg(user_rating) as avg_rating
    
from AppleStore
Group By app_type

-- Checking if apps with more supported languages have higher ratings

Select CASE
	when lang_num < 10 then '<10 languages'
    when lang_num between 10 and 30 then '10-30 languages'
    else '>30 languages'
    end as languages_supported,
    avg(user_rating) as avg_rating
    
from AppleStore
GROUP BY languages_supported
order by avg_rating desc

-- Checking which genres have the lowest ratings

select prime_genre,
	avg(user_rating) as avg_rating
    
From AppleStore
group by prime_genre
ORDER by avg_rating ASC
limit 10

-- Checking if there is correlation between the length of the app description and the user rating

SELECT 
	avg(length(app_desc)) as AvgLength,
    max(length(app_desc)) as MaxLength,
    min(length(app_desc)) as MinLength,
    count(length(app_desc = 0)) as NoDescription
    
From applestore_description_combined


SELECT CASE
	when length(b.app_desc) <500 then 'Short'
    when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
    else 'Long'
    end as description_length,
    avg(a.user_rating) as avg_rating
    
from AppleStore as a
	 JOIN
     applestore_description_combined as b
	 on a.id = b.id
     
group by description_length
order by avg_rating desc

-- Checking the top rated apps in each genre
 
Select prime_genre,
       track_name,
       user_rating
FROM (
  	  SELECT prime_genre,
  			 track_name,
  			 user_rating,
  		RANK() OVER
  		(
        PARTITION by prime_genre
        order by user_rating DESC,
        		 rating_count_tot DESC
        )
      as rank
      from AppleStore
      )
      as a 
where 
a.rank = 1

    
    



