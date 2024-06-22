WITH ProjectGroups AS (
    SELECT
        Task_ID,
        Start_Date,
        End_Date,
        ROW_NUMBER() OVER (ORDER BY Start_Date) - 
        ROW_NUMBER() OVER (PARTITION BY DATEADD(day, -ROW_NUMBER() OVER (ORDER BY Start_Date), Start_Date) ORDER BY Start_Date) AS ProjectGroup
    FROM Projects
),
ProjectSummary AS (
    SELECT
        MIN(Start_Date) AS Project_Start_Date,
        MAX(End_Date) AS Project_End_Date,
        DATEDIFF(day, MIN(Start_Date), MAX(End_Date)) + 1 AS Completion_Days
    FROM ProjectGroups
    GROUP BY ProjectGroup
)
SELECT
    Project_Start_Date,
    Project_End_Date
FROM ProjectSummary
ORDER BY
    Completion_Days,
    Project_Start_Date;


SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Friends bf ON f.Friend_ID = bf.ID
JOIN Packages ps ON s.ID = ps.ID
JOIN Packages pbf ON bf.ID = pbf.ID
WHERE pbf.Salary > ps.Salary
ORDER BY pbf.Salary;


SELECT DISTINCT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X < f1.Y
ORDER BY f1.X, f1.Y;

SELECT
    contest_id,
    hacker_id,
    name,
    SUM(total_submissions) AS total_submissions,
    SUM(total_accepted_submissions) AS total_accepted_submissions,
    SUM(total_views) AS total_views,
    SUM(total_unique_views) AS total_unique_views
FROM (
    SELECT
        c.contest_id,
        c.hacker_id,
        h.name,
        COALESCE(c.total_submissions, 0) AS total_submissions,
        COALESCE(c.total_accepted_submissions, 0) AS total_accepted_submissions,
        COALESCE(c.total_views, 0) AS total_views,
        COALESCE(c.total_unique_views, 0) AS total_unique_views
    FROM contests c
    LEFT JOIN hackers h ON c.hacker_id = h.hacker_id
) AS aggregated_stats
GROUP BY contest_id, hacker_id, name
HAVING
    SUM(total_submissions) > 0
    OR SUM(total_accepted_submissions) > 0
    OR SUM(total_views) > 0
    OR SUM(total_unique_views) > 0
ORDER BY contest_id;


WITH Dates AS (
    SELECT DATE '2016-03-01' + INTERVAL seq.seq DAY AS submission_date
    FROM (
        SELECT generate_series(0, 14) AS seq
    ) AS seq
),
DailySubmissions AS (
    SELECT
        s.submission_date,
        s.hacker_id,
        COUNT(DISTINCT s.hacker_id) AS unique_hackers,
        MAX(s.num_submissions) AS max_submissions
    FROM (
        SELECT
            DATE(s.submission_time) AS submission_date,
            s.hacker_id,
            COUNT(*) AS num_submissions
        FROM submissions s
        WHERE DATE(s.submission_time) BETWEEN '2016-03-01' AND '2016-03-15'
        GROUP BY DATE(s.submission_time), s.hacker_id
    ) AS s
    GROUP BY s.submission_date, s.hacker_id
),
MaxSubmissionsPerDay AS (
    SELECT
        submission_date,
        MAX(max_submissions) AS max_submissions
    FROM DailySubmissions
    GROUP BY submission_date
)
SELECT
    d.submission_date,
    COALESCE(ds.unique_hackers, 0) AS total_unique_hackers,
    COALESCE(ds.hacker_id, '') AS hacker_id_with_max_submissions,
    COALESCE(h.name, '') AS hacker_name_with_max_submissions,
    COALESCE(MAX(ds.max_submissions), 0) AS max_submissions_per_day
FROM Dates d
LEFT JOIN DailySubmissions ds ON d.submission_date = ds.submission_date
LEFT JOIN hackers h ON ds.hacker_id = h.hacker_id AND ds.max_submissions = h.max_submissions
LEFT JOIN MaxSubmissionsPerDay ms ON d.submission_date = ms.submission_date AND ds.max_submissions = ms.max_submissions
GROUP BY d.submission_date, ds.unique_hackers, ds.hacker_id, h.name

SELECT ROUND(ABS(MIN(LONG_W) - MAX(LONG_W)) + ABS(MIN(LAT_N) - MAX(LAT_N)), 4) AS Manhattan_Distance
FROM STATION;

SELECT LISTAGG(prime_number, '&') WITHIN GROUP (ORDER BY prime_number) AS primes_up_to_1000
FROM (
    SELECT DISTINCT Num AS prime_number
    FROM (
        SELECT LEVEL AS Num
        FROM dual
        CONNECT BY LEVEL <= 1000
    )
    WHERE Num > 1
    MINUS
    SELECT Num
    FROM (
        SELECT LEVEL AS Num
        FROM dual
        CONNECT BY LEVEL <= 1000
    )
    CONNECT BY PRIOR Num < LEVEL
);


SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY Occupation;

SELECT
    c.company_code,
    c.founder_name,
    COUNT(DISTINCT CASE WHEN e.position = 'lead_manager' THEN e.employee_id END) AS total_lead_managers,
    COUNT(DISTINCT CASE WHEN e.position = 'senior_manager' THEN e.employee_id END) AS total_senior_managers,
    COUNT(DISTINCT CASE WHEN e.position = 'manager' THEN e.employee_id END) AS total_managers,
    COUNT(DISTINCT e.employee_id) AS total_employees
FROM Companies c
LEFT JOIN Employees e ON c.company_id = e.company_id
GROUP BY c.company_code, c.founder_name
ORDER BY LENGTH(c.company_code), c.company_code;

SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Packages sp ON s.ID = sp.ID
JOIN Packages fp ON f.Friend_ID = fp.ID
WHERE fp.Salary > sp.Salary
ORDER BY fp.Salary;

SELECT
    job_family,
    SUM(CASE WHEN region = 'India' THEN cost END) / SUM(cost) * 100 AS India_percentage,
    SUM(CASE WHEN region = 'International' THEN cost END) / SUM(cost) * 100 AS International_percentage
FROM job_cost_data
GROUP BY job_family;

SELECT
    business_unit,
    SUM(cost) AS total_cost,
    SUM(revenue) AS total_revenue,
    SUM(cost) / SUM(revenue) AS cost_to_revenue_ratio
FROM bu_monthly_data
GROUP BY business_unit;

SELECT
    sub_band,
    COUNT(employee_id) AS headcount,
    COUNT(employee_id) / (SELECT COUNT(*) FROM employees) * 100 AS headcount_percentage
FROM employees
GROUP BY sub_band;

SELECT *
FROM employees e1
WHERE 5 >= (SELECT COUNT(DISTINCT e2.salary) 
            FROM employees e2 
            theth two but even So

SELECT CEIL(ABS(actual_avg_salary - miscalculated_avg_salary)) AS error_amount
FROM (
    SELECT AVG(salary) AS actual_avg_salary,
           AVG(CASE WHEN salary <> 0 THEN salary END) AS miscalculated_avg_salary
    FROM EMPLOYEES
) subquery;

