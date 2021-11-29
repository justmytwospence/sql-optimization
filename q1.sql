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

-- 1. List the name of the student with id equal to v1 (id).

-- The bottleneck here is the fact that there is no index on the id field of the Student table.
-- This is discoverable by looking at the execution plan for the query and noticing that no keys are being used.
EXPLAIN SELECT name FROM Student WHERE id = @v1;

-- The solution is to create an index.
CREATE INDEX Student_id_IDX USING BTREE ON springboardopt.Student (id);

-- Then another EXPLAIN reveals that the new index is being used aind only 1 row is estimated to be read.
EXPLAIN SELECT name FROM Student WHERE id = @v1;
