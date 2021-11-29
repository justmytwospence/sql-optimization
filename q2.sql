USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';
SET @v8 = 'MAT';

-- 2. List the names of students with id in the range of v2 (id) to v3 (inclusive).

-- The potential bottleneck here is that MySQL is choosing not to use the index
-- we previously created on Student.id, probably because the table is small
-- enough relative to our where clause range that it is not helpful.

-- This is discoverable by looking at the execution plan for the query and
-- noticing that although the Student.id index is noted as a possible key, it is
-- not actually being used.
EXPLAIN SELECT name FROM Student WHERE id BETWEEN @v2 AND @v3;

-- If we wanted to force use of the index, we can do so:
SELECT name
FROM Student
FORCE INDEX (Student_id_IDX)
WHERE id BETWEEN 1145072 AND 1828467;

-- This does not appreciably improve the ~3ms run time of the query, however,
-- suggesting that MySQL is correct to use a full table scan in this instance.