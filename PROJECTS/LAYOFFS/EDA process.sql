# ITs an EDA (explore data analysis) process, And we'll do it in the form of questions.

#1. What is the total number of rows in the data?
WITH numberd AS (
SELECT*,
ROW_NUMBER() OVER(ORDER BY total_laid_off DESC) AS row_num
FROM layoffs_staging
)
SELECT MAX(row_num) AS last_row_number
FROM numberd;
# 1995


/*
2. How many unique companies?
3. How many unique countries?
4. How many different industries are there?
5. How many different stages does a company have?
*/
SELECT COUNT(DISTINCT company) AS num_of_com,
COUNT(DISTINCT country) AS num_of_countries,
COUNT(DISTINCT industry) num_of_industries,
COUNT(DISTINCT stage) num_of_stage
FROM layoffs_staging;
/* 
2. 1628
3. 51
4. 30
5. 16
*/


#6. Which country has the most layoffs?
SELECT country,
SUM(total_laid_off) AS total_laid_off_per_country
FROM layoffs_staging
WHERE (country IS NOT NULL AND country != '') 
AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY country
ORDER BY total_laid_off_per_country DESC;
# United States


#7. Which country has the fewest layoffs?
SELECT country,
SUM(total_laid_off) AS total_laid_off_per_country
FROM layoffs_staging
WHERE(country IS NOT NULL AND country != '') AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY country
ORDER BY total_laid_off_per_country ASC;
# Poland


#8. Which company had the most layoffs?
SELECT company,
SUM(total_laid_off) AS total_laid_off_per_country
FROM layoffs_staging
WHERE(company IS NOT NULL AND company != '') 
AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY company
ORDER BY total_laid_off_per_country DESC;
#Amazon


#9. Which company had the fewest layoffs?
SELECT company,
SUM(total_laid_off) AS total_laid_off_per_country
FROM layoffs_staging
WHERE(company IS NOT NULL AND company != '') AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY company
ORDER BY total_laid_off_per_country ASC;
#Branch


#10. Which industry is most affected by layoffs?
SELECT industry,
SUM(total_laid_off) AS total_laid_off_per_country
FROM layoffs_staging
WHERE(industry IS NOT NULL AND industry != '') AND
(total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY industry
ORDER BY total_laid_off_per_country DESC;
#Consumer


#11. Which industry has the least layoffs?
SELECT industry,
SUM(total_laid_off) AS total_laid_off_per_country
FROM layoffs_staging
WHERE(industry IS NOT NULL AND industry != '') AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY industry
ORDER BY total_laid_off_per_country ASC;
#Manfacturing


/*
12. What is the average number of layoffs
13. What is the highest number of layoffs in a single row?
14. What is the lowest number of layoffs?
15. What is the average layoff rate?
16. What is the highest layoff rate?
17. What is the lowest layoff rate?
*/
SELECT 
AVG(total_laid_off) AS average_number_of_layoffs,
MAX(total_laid_off) AS highest_number_of_layoffs_in_a_single_row,
MIN(total_laid_off) AS lowest_number_of_layoffs,
CONCAT (ROUND (AVG (percentage_laid_off), 4)*100, '%') AS average_number_of_percentage_laid_off,
CONCAT (MAX (percentage_laid_off)*100, '%') AS highest_percentage_laid_off,
CONCAT (MIN (percentage_laid_off)*100, '%') AS lowest_percentage_laid_off
FROM layoffs_staging;
/*
12. 237.2659
13. 12000
14. 3
15. 25.8%
16. 100%
17. 0%
*/


/*18. Which year had the highest number of layoffs?
  19. Which year had the lowest number of layoffs?
  */
WITH yearly_layoffs AS (
SELECT YEAR(`date`) AS year_date,
SUM(total_laid_off) AS num_layoffs_in_one_year
FROM layoffs_staging
WHERE `date` IS NOT NULL
GROUP BY YEAR(`date`)
)
SELECT *
FROM yearly_layoffs
WHERE num_layoffs_in_one_year = (SELECT MAX(num_layoffs_in_one_year) FROM yearly_layoffs)
OR 	  num_layoffs_in_one_year = (SELECT MIN(num_layoffs_in_one_year) FROM yearly_layoffs);
/* highest number of layoffs was in 2022 with 160661 layoffs,
lowest number of layoffs was in 2021 with 15823 layoffs
*/


/*
20. Which specific month had the highest number of layoffs?
21. Which specific month had the lowest number of layoffs?
*/
WITH monthly_layoffs AS (
SELECT 
DATE_FORMAT (`date`, '%m-%Y')AS month_order,
SUM(total_laid_off) AS num_layoffs_in_specific_month
FROM layoffs_staging
WHERE `date` IS NOT NULL
GROUP BY DATE_FORMAT (`date`, '%m-%Y')
)
SELECT *
FROM monthly_layoffs
WHERE num_layoffs_in_specific_month = 
	(SELECT MAX(num_layoffs_in_specific_month) FROM monthly_layoffs)
OR 	  num_layoffs_in_specific_month = 
	(SELECT MIN(num_layoffs_in_specific_month) FROM monthly_layoffs);
/* 
01-2023 was the heighst number of layoffs with 84714 layoffs 
10-2021 was the lowest with just 22 layoffs
*/


#22. Is there a clear trend in the number of layoffs over time? (Increase or decrease)
WITH monthly_order AS (
SELECT 
YEAR(`date`) AS year,
MONTH(`date`) AS month,
SUM(total_laid_off) AS num_layoffs_in_specific_month
FROM layoffs_staging
WHERE `date` IS NOT NULL
GROUP BY YEAR(`date`), MONTH(`date`)
)
SELECT 
CONCAT(LPAD(month, 2, '0'),'-',year) month_order,
num_layoffs_in_specific_month
FROM monthly_order
ORDER BY year, month;
/*We can see that the study starts from 03/2020, 
and this date is the beginning of the lockdown due to the global Corona pandemic, 
which led to an increase in the number of job layoffs, 
reaching its peak in 2022 and 2023.
*/


#23. Which company laid off the most employees in each country?
WITH laid_employees AS (
SELECT country, company,
SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging
WHERE (company IS NOT NULL AND company != '') 
AND (country IS NOT NULL AND country != '')
AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY country, company
),
ranked AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY country ORDER BY num_of_layoffs DESC) AS rn
FROM laid_employees
)
SELECT country, company, num_of_layoffs
FROM ranked
WHERE rn = 1
ORDER BY num_of_layoffs DESC;


#24. Which company had the most layoffs each year?
WITH laid_employees AS (
SELECT company, YEAR(`date`) AS year,
SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging
WHERE (company IS NOT NULL AND company != '') 
AND (YEAR(`date`) IS NOT NULL)
AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY YEAR(`date`), company
),
ranked AS (
SELECT *,
RANK() OVER(PARTITION BY year ORDER BY num_of_layoffs DESC) AS rn
FROM laid_employees
)
SELECT year, company, num_of_layoffs
FROM ranked 
WHERE rn = 1
ORDER BY year ;


#25. Which company has the highest number of employee layoffs in each month each year?
WITH laid_employees AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month,
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging
WHERE (company IS NOT NULL AND company != '') 
	AND (YEAR(`date`) IS NOT NULL)
	AND (MONTH(`date`) IS NOT NULL)
	AND (total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY YEAR(`date`), MONTH(`date`), company
),
ranked AS (
  SELECT *,
  RANK() OVER(PARTITION BY the_year, the_month ORDER BY num_of_layoffs DESC) AS rn
  FROM laid_employees
)
SELECT 
  CONCAT(LPAD(the_month, 2, '0'), '-', the_year) AS the_date,
  company,
  num_of_layoffs
FROM ranked 
WHERE rn = 1
ORDER BY the_year, the_month;


#26. Which industry has had the most layoffs in each country?
WITH total_layofs AS (
SELECT 
	country, 
    industry,
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging
WHERE 
(country IS NOT NULL AND country != '') AND
(industry IS NOT NULL AND industry != '') AND
(total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY country, industry
),
ranked AS(
SELECT *,
RANK() OVER(PARTITION BY country ORDER BY num_of_layoffs DESC) AS rn
FROM total_layofs
)
SELECT
	country,
    industry,
    num_of_layoffs
FROM ranked
WHERE rn = 1
ORDER BY num_of_layoffs DESC;


#27. whitch stage have the heighst averege of layoffs
SELECT stage,
AVG(total_laid_off) AS avg_laiyoffs
FROM layoffs_staging
GROUP BY stage 
ORDER BY avg_laiyoffs DESC
LIMIT 1;


#28. Which companies raised the most funds and had the most layoffs?
SELECT company,
SUM(total_laid_off) AS num_of_layoffs,
SUM(funds_raised_millions) AS num_of_funds
FROM layoffs_staging
WHERE (company IS NOT NULL AND company != '') AND
	(total_laid_off IS NOT NULL AND total_laid_off != '') AND
    (funds_raised_millions IS NOT NULL AND funds_raised_millions != '')
GROUP BY company 
ORDER BY num_of_funds DESC;


#29. Which countries have the highest average percentege layoff rate?
WITH avg_of_percentege AS(
SELECT 
AVG(percentage_laid_off) AS ovarall_avg
FROM layoffs_staging
),
avg_percentage_of_countries AS (
SELECT country,
AVG(percentage_laid_off) as Percentage_laid_off,
(SELECT ovarall_avg FROM avg_of_percentege) AS ovarall_avg
FROM layoffs_staging 
GROUP BY country
),
avg_of_avg AS (
SELECT *
FROM avg_percentage_of_countries
WHERE Percentage_laid_off > ovarall_avg
)
SELECT country, Percentage_laid_off 
FROM avg_of_avg
ORDER BY Percentage_laid_off DESC;


#30. Which company had the highest number of layoffs in March for each year from 2020 to 2023?
WITH march_layoffs AS (
SELECT company, 
YEAR(`date`) AS the_year,
SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging
WHERE MONTH(`date`) = 3 AND
(YEAR(`date`) BETWEEN 2020 AND 2023) AND
(company IS NOT NULL AND company != '') AND
(total_laid_off IS NOT NULL AND total_laid_off != '')
GROUP BY company, YEAR(`date`)
),
ranked AS (
SELECT *, 
RANK() OVER (PARTITION BY the_year ORDER BY num_of_layoffs DESC) AS rn
FROM march_layoffs
)
SELECT the_year, company, num_of_layoffs
FROM ranked
WHERE rn = 1
ORDER BY the_year ;

#31. Which company had the highest number of layoffs per quarter per year?
WITH 1st_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    (YEAR(`date`) = 2020 AND MONTH(`date`) BETWEEN 3 AND 6)
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
), 
2nd_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    (YEAR(`date`) = 2020 AND MONTH(`date`) BETWEEN 7 AND 10)
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
3rd_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    ((YEAR(`date`) = 2020 AND MONTH(`date`) BETWEEN 11 AND 12) OR 
    (YEAR(`date`) = 2021 AND MONTH(`date`) BETWEEN 1 AND 2))
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
4th_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    (YEAR(`date`) = 2021 AND MONTH(`date`) BETWEEN 3 AND 6)
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
5th_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    (YEAR(`date`) = 2021 AND MONTH(`date`) BETWEEN 7 AND 10)
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
6th_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    ((YEAR(`date`) = 2021 AND MONTH(`date`) BETWEEN 11 AND 12) OR 
    (YEAR(`date`) = 2022 AND MONTH(`date`) BETWEEN 1 AND 2))
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
7th_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    (YEAR(`date`) = 2022 AND MONTH(`date`) BETWEEN 3 AND 6)
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
8th_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    (YEAR(`date`) = 2022 AND MONTH(`date`) BETWEEN 7 AND 10)
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
9th_quarter AS (
SELECT 
	company, 
	YEAR(`date`) AS the_year, 
	MONTH(`date`) AS the_month, 
	SUM(total_laid_off) AS num_of_layoffs
FROM layoffs_staging 
WHERE 
	(company IS NOT NULL AND company != '') AND
    (YEAR(`date`) IS NOT NULL) AND
    (MONTH(`date`) IS NOT NULL) AND
    (total_laid_off IS NOT NULL AND total_laid_off != '') AND
    ((YEAR(`date`) = 2022 AND MONTH(`date`) BETWEEN 11 AND 12) OR 
    (YEAR(`date`) = 2023 AND MONTH(`date`) BETWEEN 1 AND 2))
GROUP BY company, YEAR(`date`), MONTH(`date`)
ORDER BY num_of_layoffs DESC
LIMIT 1
),
union_all AS (
SELECT * 
FROM 1st_quarter
UNION 
SELECT * 
FROM 2nd_quarter
UNION 
SELECT * 
FROM 3rd_quarter
UNION 
SELECT * 
FROM 4th_quarter
UNION 
SELECT * 
FROM 5th_quarter
UNION 
SELECT * 
FROM 6th_quarter
UNION 
SELECT * 
FROM 7th_quarter
UNION 
SELECT * 
FROM 8th_quarter
UNION 
SELECT * 
FROM 9th_quarter
)
SELECT 
	company,
    CONCAT(LPAD(the_month, 2, '0'), '-', the_year) AS Quarters,
    num_of_layoffs
FROM union_all
ORDER BY num_of_layoffs DESC;
/*There may be shorter methods than this one, 
but after testing every possible approach, 
none matched the accuracy of this method. */


/*This marks the end of the “How to Perform EDA” 
series — a collection of 30 questions designed to progress from simple to advanced.
Always remember that Exploratory Data Analysis (EDA) isn’t about following a fixed set of steps, 
but rather about asking the right questions and finding the answers within the data.

That’s the essence of real-world EDA — understanding, questioning, and making data-driven decisions.

All you need to do is turn what you want to uncover into a clear question,
and the answers will naturally reveal themselves through your analysis.

Don’t stop here — there are many other methods and tools you can explore to achieve the same goals.
However, in this file, I aimed to present the process in the simplest and most practical way possible,
to serve as a starting point or reference for anyone — or any organization — 
looking to understand EDA from a hands-on perspective.
*/









