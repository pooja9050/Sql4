#2004 The Number of Seniors and Juniors to Join the Company
# Write your MySQL query statement below
WIth CTE AS (SELECT employee_id, experience, SUM(salary) OVER(PARTITION BY experience Order by salary) AS 'rsum'
FROM Candidates)
SELECT 'Senior' AS experience, COUNT(employee_id) AS 'accepted_candidates'
FROM CTE WHERE experience = 'Senior' AND rsum <=70000
UNION
 SELECT 'Junior'AS experience, COUNT(employee_id) AS 'accepted_candidates'
FROM CTE WHERE experience = 'Junior' AND rsum <=(
    SELECT 70000 - IFNULL(Max(rsum),0) FROM CTE WHERE experience = 'Senior' AND rsum <=70000
);


# If hire Either senior or junior using more than one common table expression cte
With CTE AS(
    SELECT employee_id, experience, SUM(salary) OVER(PARTITION BY experience ORDER BY salary) AS 'rsum' FROM Candidates
),
ACTE AS (
    SELECT 70000-IFNULL(MAX(rsum),0) AS 'remaining' FROM CTE WHERE experience = 'Senior' AND rsum <=70000
)

SELECT 'Senior' AS experience , COUNT(employee_id) AS accepted_candidates FROM CTE
WHERE experience = 'Senior' AND rsum <= 70000
UNION
SELECT 'Junior' AS experience, COUNT(employee_id) AS accepted_candidates FROM CTE
Where experience = 'Junior' AND rsum <= (SELECT remaining FROM ACTE);

