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

-- 3. List the names of students who have taken course v4 (crsCode).

-- SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);

-- The bottleneck in this case is the extra subquery that needs to be executed.
-- Not only is this an extra query, but the execution plan reveals that the
-- subquery prevents the Student.id index from being used.

-- This extra query can be eliminating by using a join instead:

SELECT name
FROM Student
INNER JOIN Transcript on Student.id = Transcript.studId
WHERE crsCode = @v4;

-- Examining the execution plan of this new query reveals that there are fewer
-- operations being performed, and that the Student.id index is now being used.

-- To further optimize, we can put an index on the crsCode field of the
-- Transcript table:
CREATE INDEX Transcript_crsCode_IDX USING BTREE ON springboardopt.Transcript
(crsCode);

-- Now the execution plan reveals that only 2 rows are being read on Transcript
-- table and 1 row on the Student table