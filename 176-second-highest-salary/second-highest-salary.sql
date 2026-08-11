WITH CTE AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM Employee
)
SELECT MAX(Salary) AS SecondHighestSalary
FROM CTE
WHERE rnk = 2;