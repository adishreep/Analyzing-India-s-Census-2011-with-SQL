#Q1. Total number of records in the census table
select count(*) from census11;

-- ______________________________________________________________________________________________________

# Q2. Total population of India as per the census

select sum(population) as total_population from census11;

-- _______________________________________________________________________________________________________

# Q3.  What is the Male to Female ratio of population

select sum(male) total_male, sum(female) total_female, sum(male)/sum(female) as ratio, 
round(sum(male)/sum(female)*1000,0) as male_per_1000_female
from census11;

-- ________________________________________________________________________________________________________

# Q4. How many states and UTs are there as per census from which data is collected

select count(distinct `state name`) from census11;

-- ________________________________________________________________________________________________________

# Q5. Which State has the highest population in India

select `state name`, sum(population) as Total_Population
from census11
group by `state name`
order by total_population desc limit 1;

-- ________________________________________________________________________________________________________

# Q5. Which State/UT has the lowest population in India

select `state name`, sum(population) as Total_Population
from census11
group by `state name`
order by total_population limit 1;

-- ________________________________________________________________________________________________________

# Q6.  What is the literacy rate of India as per census

select sum(literate)/sum(population)*100 as Literacy_rate
from literacy as l join census11 as c
using(`District code`);

-- ________________________________________________________________________________________________________

# Q7.  What is the Male literacy rate of India as per census 

select sum(male_literate)/sum(male)*100 as Male_LiteracyRate
from literacy as l join census11 as c
using(`District code`);

-- ________________________________________________________________________________________________________

# Q8.  What is the Female literacy rate of India as per census

select sum(female_literate)/sum(female)*100 as Female_LiteracyRate
from literacy as l join census11 as c
using(`District code`);

-- ________________________________________________________________________________________________________

# Q9. Which are the 5 most literate State/UT in India

select `State name`,sum(literate)/sum(population)*100 as Literacy_rate
from literacy as l join census11 as c
using(`District code`)
group by `state name`
order by Literacy_rate desc limit 5; 
-- ________________________________________________________________________________________________________

# Q10. Which are the 5 least literate State/UT in India

select `State name`,sum(literate)/sum(population)*100 as Literacy_rate
from literacy as l join census11 as c
using(`District code`)
group by `state name`
order by Literacy_rate limit 5; 
-- ________________________________________________________________________________________________________

# Q11. Which District in India has the highest literate population of India

select c.`district name`,sum(literate)/sum(population)*100 as Literacy_rate, `state name`
from literacy as l join census11 as c
using(`District code`)
group by c.`district name`
order by Literacy_rate desc limit 1;

-- ________________________________________________________________________________________________________

# Q12. Which District in India has the lowest literate population of India

select c.`district name`,sum(literate)/sum(population)*100 as Literacy_rate, `state name`
from literacy as l join census11 as c
using(`District code`)
group by c.`district name`
order by Literacy_rate limit 1; 
-- ________________________________________________________________________________________________________
 
# Q13. What percentage of India's total population is working population

select round(sum(workers)/sum(population)*100,0) as working_population
from census11 join workers using(`district code`); 
-- ________________________________________________________________________________________________________

# Q14. What percentage of workers in Inida are women

select sum(female_workers)/sum(workers)*100 as `Percentage of Female worker`
from workers;
-- ________________________________________________________________________________________________________

# Q15. What percentage of workers in Inida are men

select sum(male_workers)/sum(workers)*100 as `Percentage of Male worker`
from workers;
-- ________________________________________________________________________________________________________

# Q16. Which are the top 3 States/UTs with highest percentage of female workers

select `state name`, sum(female_workers)/sum(workers)*100 as `percentage of female workers`
from census11 join workers
using(`district code`)
group by `state name`
order by `percentage of female workers` desc
limit 3;

-- ________________________________________________________________________________________________________

# Q17. Which are the top 3 States/UTs with highest percentage of Male workers

select `state name`, sum(male_workers)/sum(workers)*100 as `percentage of male workers`
from census11 join workers
using(`district code`)
group by `state name`
order by `percentage of male workers` desc
limit 3;
-- ________________________________________________________________________________________________________

# Q18. what percentage of households in India is with a LPG connection

select sum(LPG_Households)/sum(households)*100 as `Percentage of households with LPG`
from census11; 
-- ________________________________________________________________________________________________________

# Q19. Rank the districts from each State based on highest to lowest percentage of houseeholds with LPG 
-- connection

with subq as (select `state name`,`district name`, sum(LPG_Households)/sum(households)*100 as 
			  'Percentage of household with LPG'
              from census11
              group by `district name`
              )
select `state name`,`district name`, `Percentage of household with LPG`, dense_rank()
over( partition by `state name` order by `Percentage of household with LPG` desc) as ranking
from subq;
-- ________________________________________________________________________________________________________

# Q20.  Find top 3 districts from each state with highest percentage of households with LPG Connection

SELECT `State Name`, `District Name`, (LPG_households / Households) * 100 AS Percentage_LPG, ranking
FROM (
    SELECT `State Name`, `District Name`, Households, LPG_households,
           ROW_NUMBER() OVER (PARTITION BY `State Name` ORDER BY (LPG_households / Households)  DESC) AS 
           Ranking
    FROM census11
) AS RankedData
WHERE Ranking <= 3;
-- ________________________________________________________________________________________________________

# Q21. which state has the highest and lowest percentage of households with LPG connection

SELECT
  (SELECT `State Name`
   FROM census11
   GROUP BY `State Name`
   ORDER BY (SUM(LPG_households) / SUM(Households))*100 DESC
   LIMIT 1) AS State_With_Highest_LPG,
  (SELECT `State Name`
   FROM census11
   GROUP BY `State Name`
   ORDER BY (SUM(LPG_households) / SUM(Households))*100 ASC
   LIMIT 1) AS State_With_Lowest_LPG;

-- ________________________________________________________________________________________________________

# Q22. what percentage of households in India is with electricity connection

select round(sum(Housholds_with_Electricity)/sum(households)*100,2) as 
'Percentage of households with electricity'
from census11; 
-- ________________________________________________________________________________________________________

# Q23. which State/UT has the highest percentage of households with Electricity connection

select `state name`, round(sum(Housholds_with_Electricity)/sum(households)*100,2) as 
`Percentage of households with electricity`
from census11
group by `state name`
order by `Percentage of households with electricity` desc
limit 5;
-- ________________________________________________________________________________________________________
 
# Q24. which State/UT has the lowest percentage of households with Electricity connection
select `state name`, round(sum(Housholds_with_Electricity)/sum(households)*100,2) as 
`Percentage of households with electricity`
from census11
group by `state name`
order by `Percentage of households with electricity` 
limit 5;
-- ________________________________________________________________________________________________________

# Q25. what percentage of households in India is with Internet connection

select round(sum(Households_with_Internet)/sum(households)*100,2)
as `Percentage of households with Internet`
from census11; 
-- ________________________________________________________________________________________________________

# Q26. What percentage of total households in India are rural households

select round(sum(Rural_Households)/sum(households)*100,2)
as `Percentage of rural households`
from census11;
-- ________________________________________________________________________________________________________

# Q27. which State/UT has the highest and lowest percentage of rural households in India

SELECT
  (SELECT `State Name`
   FROM census11
   GROUP BY `State Name`
   ORDER BY (SUM(Rural_Households) / SUM(Households))*100 DESC
   LIMIT 1) AS State_With_Highest_Rural_population,
  (SELECT `State Name`
   FROM census11
   GROUP BY `State Name`
   ORDER BY (SUM(Rural_Households) / SUM(Households))*100 ASC
   LIMIT 1) AS State_With_Lowest_Rural_population;
   
   -- _____________________________________________________________________________________________________
   
# Q28. What percentage of total households in India are urban households

select round(sum(urban_Households)/sum(households)*100,2)
as `Percentage of Urban households`
from census11;   

-- ________________________________________________________________________________________________________

# Q29. which State/UT has the highest and lowest percentage of Urban households in India

SELECT
  (SELECT `State Name`
   FROM census11
   GROUP BY `State Name`
   ORDER BY (SUM(urban_Households) / SUM(Households))*100 DESC
   LIMIT 1) AS State_With_Highest_Rural_population,
  (SELECT `State Name`
   FROM census11
   GROUP BY `State Name`
   ORDER BY (SUM(urban_Households) / SUM(Households))*100 ASC
   LIMIT 1) AS State_With_Lowest_Rural_population;
   
   -- _____________________________________________________________________________________________________
   
# 30. Create a view of States/UTs where literacy rate is above 50%

create view Literate_States as
select `state name`, sum(literate)/sum(population)*100 as Literacy_rate
from literacy as l join census11 as c
using(`District code`) 
group by `state name`
having Literacy_rate >60;

-- ________________________________________________________________________________________________________
   