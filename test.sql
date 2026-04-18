CREATE TABLE user_sessions (
    user_id INT,
    session_start DATETIME,
    session_end DATETIME
);

INSERT INTO user_sessions (user_id, session_start, session_end) VALUES
(1, '2024-01-01 10:00:00', '2024-01-01 10:30:00'),
(1, '2024-01-01 10:20:00', '2024-01-01 11:00:00'),
(1, '2024-01-01 11:05:00', '2024-01-01 11:30:00'),
(1, '2024-01-01 12:00:00', '2024-01-01 12:30:00'),
(2, '2024-01-01 09:00:00', '2024-01-01 09:30:00'),
(2, '2024-01-01 09:39:00', '2024-01-01 10:00:00');


SELECT * FROM user_sessions

-- ;WITH c AS (SELECT * , LEAD(session_start) OVER(ORDER BY user_id) as ab
-- FROM user_sessions)

-- SELECT * , CASE
--     WHEN session_end > ab or ab is NULL THEN 1 
--     ELSE 0
-- END AS is_overlapping
-- FROM C
--  -- WHERE session_end < DATEADD(MINUTE, +10, ab)



-- ;with c as (SELECT * , LEAD(session_start) OVER(PARTITION BY user_id ORDER BY session_start) as ab, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY session_start ) as rw FROM user_sessions)

-- SELECT *,
-- CASE
--     WHEN session_end >= DATEADD(MINUTE, 10, ab) THEN 1 
--     ELSE 0
-- END AS is_overlapping
-- FROM c


-- 1

SELECT * FROm user_sessions

;WITH C as (

    SELECT *, LAG(session_end) OVER(PARTITION BY user_id ORDER BY session_start) as prev_session_end
    FROM user_sessions
),
D as (
    SELECT * ,
    CASE WHEN
    prev_session_end IS NULL THEN 1
    WHEN session_start <= DATEADD(MINUTE, 10, prev_session_end) THEN 1
    ELSE 1
    END AS is_overlapping
    FROM C
),E as (
    SELECT *, SUM(is_overlapping) OVER(PARTITION BY user_id ORDER BY session_start) as session_group
    FROM D
)

SELECT user_id, MIN(session_start) as session_start, MAX(session_end) as session_end
FROM E





--2

CREATE TABLE job_logs (
    job_id INT,
    run_date DATE,
    status VARCHAR(10)
);

INSERT INTO job_logs VALUES
(1,'2024-01-01','success'),
(1,'2024-01-02','fail'),
(1,'2024-01-03','fail'),
(1,'2024-01-04','success'),
(1,'2024-01-05','fail'),
(1,'2024-01-06','fail'),
(1,'2024-01-07','fail'),
(2,'2024-01-01','fail'),
(2,'2024-01-02','success'),
(2,'2024-01-03','fail'),
(2,'2024-01-04','fail');


SELECT * FROM job_logs


;WITH fails AS (
    SELECT *, ROW_NUMBER() OVER (PArtition BY job_id ORDER BY run_date) as rn
    FROM job_logs
    WHERE status = 'fail'
),
isl AS (
    SELECT * , DATEADD(DAY, -rn, CAST(run_date as DATE)) as prev_run_date
    FROM fails
),
streaks AS (
    SELECT job_id , MIN(run_date) as minrn, MAX(run_date) as maxrn, COUNT(*) as cnt
    FROM isl
    GROUP BY job_id, prev_run_date
),ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY job_id ORDER BY cnt DESC) as rnk
    FROM streaks
)

SELECT job_id, minrn, maxrn, cnt
FROM ranked
WHERE rnk = 1
ORDER BY job_id



--3

CREATE TABLE transactions (
    user_id INT,
    txn_date DATE,
    amount INT
);

INSERT INTO transactions VALUES
(1,'2024-01-01',100),
(1,'2024-01-02',50),
(1,'2024-01-03',70),
(1,'2024-01-04',30),
(2,'2024-01-01',200),
(2,'2024-01-03',100),
(3,'2024-01-01',40),
(3,'2024-01-02',40);


SELECT * FROM transactions

;WITH Amain AS (
    SELECT * , SUM(amount) OVER(PARTITIOn BY user_id ORDER BY txn_date) as running_total
    FROM transactions
),
Bmain AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY txn_date) as rn
    FROM Amain
    WHERE running_total >= 200
),
Cmain AS(
    SELECT DISTINCT user_id FROM transactions)

SELECT c.user_id, txn_date
FROM Cmain as c JOIN Bmain as b on c.user_id = b.user_id AND b.rn = 1
ORDER BY c.user_id




-- 4

CREATE TABLE orders (
    order_id INT
);

DECLARE @n INT = 1;

INSERT INTO orders (order_id) VALUES
(1),(2),(3),(5),(6),(9);



-- SELECT * FROM orde


-- DECLARE a CURSOR FOR SELECT order_id FROM orders 
-- FORWARD ONLY;



CREATE TABLE #temp_orders (
    rn INT
);


DECLARE @n  = (
    SELECT MAX(order_id) FROM orders
)


    

