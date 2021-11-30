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

-- 5. List the names of students who have taken a course from department v6 (deptId), but not v7.

-- SELECT * FROM Student,
-- 	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
-- 	AND studId NOT IN
-- 	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
-- WHERE Student.id = alias.studId;

-- Similar to the last query, the bottleneck here is in the unnecessary cross
-- join. If we were using a SQL dialect with the MINUS or EXCEPT operator, we
-- could use that, but because we are using MySQL we can simulate that operatin
-- with a left join. If we are comfortable with the assumption that crsCode
-- always begins with the department ID, then we can avoid extra joins on the
-- Course table and also use the index we already created on Transcript.crsCode.

WITH

v6_students AS (
  SELECT DISTINCT Student.name AS name
  FROM Transcript
  INNER JOIN Student ON Transcript.studId = Student.id
  WHERE crsCode like 'MGT%'
),

v7_students AS (
  SELECT DISTINCT Student.name AS name
  FROM Transcript
  INNER JOIN Student ON Transcript.studId = Student.id
  WHERE crsCode = 'EE%'
)

SELECT name
FROM v6_students
LEFT JOIN v7_students USING (name)
WHERE v7_students.name IS NULL;
