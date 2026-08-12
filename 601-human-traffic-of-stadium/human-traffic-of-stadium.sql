# Write your MySQL query statement below
WITH Filtered AS (
    SELECT 
        id, 
        visit_date, 
        people,
        id - ROW_NUMBER() OVER (ORDER BY id) AS grp
    FROM 
        Stadium
    WHERE 
        people >= 100
),
ValidGroups AS (
    SELECT 
        grp
    FROM 
        Filtered
    GROUP BY 
        grp
    HAVING 
        COUNT(*) >= 3
)
SELECT 
    f.id, 
    f.visit_date, 
    f.people
FROM 
    Filtered f
JOIN 
    ValidGroups vg ON f.grp = vg.grp
ORDER BY 
    f.visit_date ASC;