# Write your MySQL query statement below
WITH FirstLogins AS (
    SELECT 
        player_id, 
        MIN(event_date) AS first_login
    FROM 
        Activity
    GROUP BY 
        player_id
)
SELECT 
    ROUND(
        COUNT(A.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 
        2
    ) AS fraction
FROM 
    FirstLogins F
JOIN 
    Activity A 
    ON F.player_id = A.player_id 
   AND F.first_login = DATE_SUB(A.event_date, INTERVAL 1 DAY);