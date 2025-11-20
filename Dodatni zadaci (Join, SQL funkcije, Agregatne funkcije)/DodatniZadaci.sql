--Z2
-- a)
SELECT s.indeks broj_indeksa,
       b.bodovi broj_bodova,
       CASE
            WHEN b.bodovi BETWEEN 1 AND 5 THEN 'D'
            WHEN b.bodovi BETWEEN 6 AND 10 THEN 'C'
            WHEN b.bodovi BETWEEN 11 AND 15 THEN 'B'
            WHEN b.bodovi BETWEEN 16 AND 20 THEN 'A'
       END ocjena
FROM test.studenti s
    JOIN test.bodovi b ON s.id = b.sid;
    
-- b)
CREATE TABLE Osobe
AS SELECT * FROM test.studenti;

ALTER TABLE Osobe
ADD info VARCHAR(50);

UPDATE Osobe osob
SET osob.info = (SELECT to_char(avg(b.bodovi))
                 FROM test.studenti s
                    JOIN test.bodovi b ON s.id = b.sid
                    JOIN test.odsjeci o ON s.oid = o.id
                 WHERE s.oid = osob.oid);
                 
SELECT * 
FROM osobe;


-- Z3
/*
Daje sve zaposlenike ciji sef radi u odjelu koji ima broj manji od 40
*/
SELECT zap.first_name || ' ' || zap.last_name,
       sef.salary,
       zap.phone_number
FROM employees zap, employees sef
WHERE zap.manager_id = sef.employee_id
AND sef.department_id <= 40
ORDER BY 2 desc, 3 asc;

-- Z4
-- a
SELECT last_name || ' ' || first_name naziv,
       hire_date datum_zaposlenja,
       trunc(months_between(sysdate, hire_date), 0) "BROJ MJESECI ZAPOSLENJA"
FROM employees
ORDER BY 3;


-- b
SELECT d.department_name naziv_odjela,
       count(e.employee_id) broj_zaposlenih
FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING count(e.employee_id) IN (3, 5) OR count(e.employee_id) > 10
ORDER BY 2, 1;

-- c
CREATE TABLE Zapy 
AS SELECT * FROM employees;

UPDATE Zapy
SET salary = decode(department_id, 
                    10, salary+1000,
                    30, salary+3000,
                    40, salary+4000,
                    80, salary+3500,
                    100, salary+300,
                    salary+500);
                    
commit;
                    
select z.salary, e.salary, e.department_id
from Zapy z 
    join employees e on e.employee_id = z.employee_id;
    
    
SELECT * 
FROM user_tables;












