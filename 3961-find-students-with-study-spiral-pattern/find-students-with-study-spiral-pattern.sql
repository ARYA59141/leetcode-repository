# Write your MySQL query statement below
WITH OrderedSessions AS (
    SELECT 
        student_id,
        subject,
        session_date,
        hours_studied,
        ROW_NUMBER() OVER (
            PARTITION BY student_id 
            ORDER BY session_date ASC
        ) AS seq,
        DATEDIFF(
            LEAD(session_date) OVER (
                PARTITION BY student_id 
                ORDER BY session_date ASC
            ),
            session_date
        ) AS gap
    FROM study_sessions
),
ValidGapStudents AS (
    SELECT student_id
    FROM OrderedSessions
    GROUP BY student_id
    HAVING MAX(COALESCE(gap, 0)) <= 2
),
PatternCheck AS (
    SELECT 
        o1.student_id,
        COUNT(DISTINCT o1.subject) AS distinct_subjects,
        COUNT(DISTINCT o1.seq) AS total_sessions
    FROM OrderedSessions o1
    JOIN ValidGapStudents v 
        ON o1.student_id = v.student_id
    JOIN OrderedSessions o2 
        ON o1.student_id = o2.student_id 
       AND o1.seq + (
           SELECT COUNT(DISTINCT subject) 
           FROM OrderedSessions 
           WHERE student_id = o1.student_id
       ) = o2.seq
    WHERE o1.subject = o2.subject
    GROUP BY o1.student_id
)
SELECT 
    s.student_id,
    s.student_name,
    s.major,
    p.distinct_subjects AS cycle_length,
    SUM(o.hours_studied) AS total_study_hours
FROM PatternCheck p
JOIN Students s 
    ON p.student_id = s.student_id
JOIN OrderedSessions o 
    ON p.student_id = o.student_id
GROUP BY 
    s.student_id, 
    s.student_name, 
    s.major, 
    p.distinct_subjects
HAVING p.distinct_subjects >= 3
   AND COUNT(o.seq) >= 2 * p.distinct_subjects
ORDER BY 
    cycle_length DESC, 
    total_study_hours DESC, 
    s.student_id ASC;