--Q1  query to display the top 10 hotspots for coronavirus (COVID – 19) cases in the USA by County
--There are 10 ros in the output
select top 10 z.County,c.[8 1 2020] as cases,sum(z.TotPop) as Total_Population,avg(MedianAge) as Median_Age
from covid19us c
inner join ZipCensus z on z.Fipco=c.FIPS
group by z.County, c.[8 1 2020]
order by cases desc

--Q2 query to display male and female deaths by Country
--There are 26 rows in the output
select country as Country,
count(case when gender = 'male' then CAST(death AS INT) end) as Male,
count(case when gender = 'female' then CAST(death AS INT) end) as Female,
count(CAST(death AS INT)) as death
from COVID19general
where visiting_wuhan = 0 and symptom is null 
and Gender in ('Male', 'Female')
group by country 
order by death desc

--Q3 Query showing an age distribution chart among cases of COVI9-19 patients
--There is 1 row in the output
select 
sum(case when age>50 then 1 else 0 end) as Baby_Boomers,  
sum(case when age>34 and age<50 then 1 else 0 end) as Generation_X,
sum(case when age>=18 and age<=34 then 1 else 0 end) as Millenials ,
sum(case when  age<=17  then 1 else 0 end) as Generation
from COVID19general

--Q4 Query to check whether Family Income impact COVID 19 cases
--There are 3134 rows in the output
select z.County, c.[8 1 2020]  as Cases,avg(z.AvgHHInc) as Higher_Income, avg(z.BornInUS) as USBorn, avg(z.ForeignBorn) as NonUSBorn
from ZipCensus z
inner join covid19us c on z.Fipco=c.FIPS
group by z.County, c.[8 1 2020]
order by avg(z.AvgHHInc) desc

--Q5 Query to showing demographics among all ethnicities in US
--There are 3134 rows in the output
select z.County,c.[8 1 2020] as Cases,avg(z.NonHispBlack) as African_American 
from ZipCensus z		
inner join COVID19US c on z.Fipco=c.FIPS		
group by z.County, c.[8 1 2020]	
order by Cases desc


--Q6 Query to show confirmed cases that were reported worldwide each week
--There are 7 rows in the output
select datepart(week,reporting_date) as 'Week', count(*) as Cases 
from COVID19general
where reporting_date is not null
group by datepart(week,reporting_date)
order by week

--Q7 Query to show confirmed cases that were reported country wide each day
--There are 262 rows in the output
select country, datepart(day,reporting_date) as 'day', count(*) as Cases 
from COVID19general
where reporting_date is not null
group by country,datepart(day,reporting_date)
order by cases desc, day

--Q8 Top Ten Closest Zip Codes to the US Geographic Center (Latitude:39.80 and Longitude: -98.60 ) with COVID-19 confirmed cases
--There are 10 rows in the output
select  top 10 zc.zcta5 as ZipCode, c.[8 1 2020] as Cases,  zc.disteuc 
from COVID19US c
 join (
SELECT Fipco, zcta5, stab, totpop, latitude, longitude, disteuc
FROM (SELECT zc.*,
(CASE WHEN latitude > 39.8
THEN SQRT(SQUARE(Difference_in_Lattitude*68.9) + SQUARE(Difference_in_Longitude*SIN(latrad)*68.9))
ELSE SQRT(SQUARE(Difference_in_Lattitude*68.9) +
SQUARE(Difference_in_Longitude*SIN(centerlatrad)*68.9))
END) as disteuc
FROM (SELECT zc.*, latitude - 39.8 as Difference_in_Lattitude,
longitude - (-98.6) as Difference_in_Longitude,
latitude*PI()/180 as latrad,
39.8*PI()/180 as centerlatrad
FROM zipcensus zc)zc)  zc)zc
on c.FIPS = zc.Fipco 
order by zc.disteuc 

--Q9 Query to find difference (No. of days) between symptom_onset and reporting date
--There are 1085 rows in the ouput
select datediff(day, symptom_onset, reporting_date) as No_of_days 
from COVID19general 

--query to find No. of COVID-19 cases for each difference (No. of Days).
--There are 32 rows in the output
select datediff(day, symptom_onset, reporting_date) as no_of_days, count(*) as Cases 
from COVID19general
where datediff(day, symptom_onset, reporting_date) is not null
group by datediff(day, symptom_onset, reporting_date)

--Q10 Query to find unique symptoms of COVID-19
--There are 108 rows in the output
SELECT distinct symptom, 
sum(case when gender = 'female' then 1 else 0 end) as Females,
sum(case when gender = 'male' then 1 else 0 end) as Males 
FROM COVID19general
where symptom  is not null and gender is not null
group by symptom 