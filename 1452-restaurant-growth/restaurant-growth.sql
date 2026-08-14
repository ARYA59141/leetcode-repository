WITH DailySum AS (
    SELECT 
        visited_on, 
        SUM(amount) AS amount
    FROM 
        Customer
    GROUP BY 
        visited_on
)
SELECT 
    a.visited_on,
    SUM(b.amount) AS amount,
    ROUND(AVG(b.amount), 2) AS average_amount
FROM 
    DailySum a
JOIN 
    DailySum b 
    ON DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
GROUP BY 
    a.visited_on
HAVING 
    COUNT(b.visited_on) = 7
ORDER BY 
    a.visited_on ASC;