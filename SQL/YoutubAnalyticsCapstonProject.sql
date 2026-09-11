--Task1:- Creation of Database
create database YoutubeAnalyticsDB

use YoutubeAnalyticsDB

--Task2:- Import the Dataset
select * from GlobalYouTubeStatistics

--Task3:- Data validation & cleaning

--1.Find the total number of records available in the dataset.
select count(*) as TotalCount from GlobalYouTubeStatistics --by rows with null values count
select count(Youtuber) as Totalcount from GlobalYouTubeStatistics--by column without null values count

--2.Check whether duplicate channel names exist.
with CTE_table as 
(select Youtuber,ROW_NUMBER()over(partition by Youtuber order by Youtuber)as Rnk from GlobalYouTubeStatistics)
select * from CTE_table where Rnk>1

---
select Youtuber,count(Youtuber) as counts from GlobalYouTubeStatistics group by Youtuber having count(Youtuber)>1
--
--From both the method we can say that there is no duplicate channel name exists.

--3.Identify all columns containing Null Values.
select 
sum(case when Youtuber is null then 1 else 0 end)as Youtuber_nulls,
sum(case when subscribers is null then 1 else 0 end)as subscribers_nulls,
sum(case when video_views is null then 1 else 0 end)as video_views_nulls,
sum(case when category is null then 1 else 0 end)as category_nulls,
sum(case when Title is null then 1 else 0 end)as Title_nulls,
sum(case when uploads is null then 1 else 0 end)as uploads_nulls,
sum(case when Abbreviation is null then 1 else 0 end)as Abbreviation_nulls,
sum(case when video_views_rank is null then 1 else 0 end)as video_views_nulls
from GlobalYouTubeStatistics

--by column wise
select count(*) as total_nulls from GlobalYouTubeStatistics where video_views_rank is null

--4. Replace null values with their appropriate values.
--not require already replaced with 0 all numeric columns null values,further we have to use in Power bi so there can be cleaning done.so not needed.

--5.Verify and correct the data types of all numeric and date columns.
--for checking data types
select COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GlobalYoutubeStatistics'

select * from GlobalYouTubeStatistics

-------------------Business Problems--------------------
-->1.Display the Top 10 Youtube channels based on Subscribers.
select Top 10 *from GlobalYouTubeStatistics order by subscribers desc

-->2.Find the Top 5 countries having the highest total subscribers.
select top 5 country,sum(subscribers) as Total_subscribers from GlobalYouTubeStatistics group by country order by Total_subscribers desc

--becaue of throwing error for arithmatic overflow
alter table GlobalYoutubeStatistics alter column subscribers bigint

select top 5 country,sum(subscribers) as Total_subscribers from GlobalYouTubeStatistics group by country order by Total_subscribers desc

-->3.Display the Top 10 Categories based on total Video Views.
select Top 10 category,sum(video_views) as Total_views from GlobalYouTubeStatistics group by category order by Total_views desc

-->4.Find the channel having the Highest subscribers gain in last 30 Days.
select * from GlobalYouTubeStatistics

select Top 1 * from GlobalYouTubeStatistics order by subscribers_for_last_30_days desc

--using CTE
with highest_gain as (select max(subscribers_for_last_30_days) as highestSubscriber_gain from GlobalYouTubeStatistics)
select * from GlobalYouTubeStatistics where subscribers_for_last_30_days = (select highestSubscriber_gain
from highest_gain)

-->5.Calculate the average yearly earnings for each youtube category.
select category,avg((lowest_yearly_earnings+highest_yearly_earnings)/2) as average_yearly_earning from GlobalYouTubeStatistics group by category order by average_yearly_earning

-->6.Create a SQL View named vw_ChannelPerformance containing the following columns:
--Channel Name
--Country
--Category
--Subscribers
--Video views
--Uploads
--Highest Yearly Earnings

create or alter view vw_ChannelPerformance
as
select Youtuber as Channel_Name,Country,category,subscribers,video_views,uploads,highest_yearly_earnings
from GlobalYouTubeStatistics

select * from vw_ChannelPerformance

------------------Phase 1 Completed----------------


