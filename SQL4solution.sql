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


607. Sales Person
# Write your MySQL query statement below
SELECT s.name FROM Salesperson s WHERE s.sales_id NOT IN (SELECT o.sales_id FROM Orders o LEFT JOIN Company c
ON o.com_id = c.com_id WHERE c.name = "Red");


#Using CTE  
With CTE AS (SELECT o.sales_id FROM Orders o LEFT JOIN Company c ON o.com_id = c.com_id WHERE c.name = "Red")
SELECT s.name FROM salesperson s WHere s.sales_id NOT IN (SELECT sales_id FROM CTE);

#602. Friend Requests II: Who Has the Most Friends
# Write your MySQL query statement below
With CTE AS (
    SELECT requester_id AS r1 FROM RequestAccepted
    UNION ALL
    SELECT accepter_id as 'r1' FROM RequestAccepted),
ACTE AS (
    SELECT r1 AS 'id', COUNT(r1) AS 'num' FROM CTE GROUP BY r1)
SELECT id, num FROM ACTE ORDER BY num DESC LIMIT 1;

#Using WHERE clause
# Write your MySQL query statement below
With CTE AS (
    SELECT requester_id AS r1 FROM RequestAccepted
    UNION ALL
    SELECT accepter_id as 'r1' FROM RequestAccepted),
ACTE AS (
    SELECT r1 AS 'id', COUNT(r1) AS 'num' FROM CTE GROUP BY r1)

SELECT id, num 
FROM ACTE
WHERE num = (
    SELECT MAX(num) FROM ACTE
    );

#Alternative approach
WITH CTE AS (
    SELECT requester_id AS id, 
       (SELECT COUNT(*) 
        FROM RequestAccepted AS ra
        WHERE ra.requester_id = r.requester_id OR ra.accepter_id = r.requester_id) AS num
FROM RequestAccepted AS r
UNION ALL
SELECT accepter_id AS id,(
    SELECT COUNT(*) FROM RequestAccepted AS ra
    WHERE ra.requester_id = r.accepter_id OR ra.accepter_id = r.accepter_id) AS num
    FROM RequestAccepted AS r)

SELECT id, num FROM CTE
Order BY num DESC LIMIT 1;

