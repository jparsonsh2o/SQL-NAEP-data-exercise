--1.  Write a query to allow inspection of the schema of naep table.--
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name='naep';

--2.  Write a query that returns first 50 records of naep table.--
SELECT *
FROM naep
LIMIT 50;

--3.  Return summary stats for avg_math_4_score by state.  Sort A-Z by state name.--
SELECT state, COUNT(avg_math_4_score), ROUND(AVG(avg_math_4_score),3), MIN(avg_math_4_score), MAX(avg_math_4_score)
FROM naep
GROUP BY state
ORDER BY state;

--4.  Alter the previous query to return only states with difference in min and max of 30 or more.--
SELECT state, COUNT(avg_math_4_score), ROUND(AVG(avg_math_4_score),3) AS avg, MIN(avg_math_4_score), MAX(avg_math_4_score)
FROM naep
GROUP BY state
HAVING (ROUND(MAX(avg_math_4_score))-MIN(avg_math_4_score)) > 30;

--5.  Write a query that returns a field called bottom_10_states in year 2000.--
SELECT state AS bottom_10_states
FROM naep
WHERE year = '2000'
ORDER BY avg_math_4_score
LIMIT 10;

--6.  Calculate the average avg_math_4_score, rounded to the nearest two decimal places, over all states in the year 2000.--
SELECT ROUND(AVG(avg_math_4_score),2)
FROM naep
WHERE year = '2000';

--7.  Write a query that returns a field called below_average_states_y2000, all states with an avg_math_4_score less than the average over all states in the year 2000.
SELECT state AS below_average_states_y2000
FROM naep
WHERE avg_math_4_score < ANY
	(SELECT ROUND(AVG(avg_math_4_score),3)
	 FROM naep
	 WHERE year = '2000')
AND year = '2000';

--8. Return a field called scores_missing_y2000 for any states with missing values in avg_math_4_score for 2000.--
SELECT state AS scores_missing_y2000
FROM naep
WHERE avg_math_4_score IS NULL
  AND year = '2000';

--9.Return state,avg_math_4_score, total_expenditure for 2000.--
SELECT naep.state, ROUND(avg_math_4_score, 2) AS avg_math_4_score, total_expenditure
FROM naep
LEFT OUTER JOIN finance
ON naep.id=finance.id
WHERE naep.year = '2000'
	AND avg_math_4_score IS NOT NULL
ORDER BY total_expenditure DESC;
