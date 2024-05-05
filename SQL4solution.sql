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

#1841. League Statistics
# Write your MySQL query statement below
WITH CTE AS (
    SELECT home_team_id AS r1, away_team_id AS r2, home_team_goals AS g1, away_team_goals AS g2
    FROM Matches
    UNION ALL
    SELECT away_team_id AS r1, home_team_id AS r2, away_team_goals AS g1, home_team_goals AS g2
    FROM Matches)

SELECT t.team_name, count(r1) AS 'matches_played', SUM(
    Case
       WHEN c.g1>c.g2 Then 3
       WHEN c.g1 = c.g2 Then 1
       ELSE 0
       END) AS 'points', SUM(c.g1) AS 'goal_for', SUM(c.g2) AS 'goal_against' , SUM(c.g1) - SUM(c.g2) AS 'goal_diff' FROM Teams t JOIN CTE c ON t.team_id = c.r1 GROUP BY c.r1 Order by points DESC, goal_diff DESC, t.team_name;

