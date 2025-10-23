SELECT *
FROM jobs, employees;

-- Zadatak 1
SELECT first_name || ' ' || last_name AS Naziv,
       salary AS Plata
FROM employees
WHERE salary > 2456;

-- Zadatak 2
SELECT first_name || ' ' || last_name AS Naziv,
       department_id AS "Sifra odjela"
FROM employees
WHERE employee_id = 102;

-- Zadatak 3
SELECT *
FROM employees
WHERE salary < 1000 OR salary > 2345;

-- Zadatak 4
SELECT e.first_name || ' ' || e.last_name AS Zaposleni,
       e.job_id AS Posao,
       e.hire_date AS "Datum zaposljenja"
FROM employees e
WHERE e.hire_date BETWEEN TO_DATE('11-01-1996','DD-MM-YYYY') AND TO_DATE('22-02-1997','DD-MM-YYYY');

-- Zadatak 5
SELECT first_name || ' ' || last_name AS Naziv,
       department_id AS "Sifra odjela"
FROM employees
WHERE department_id = 10 OR department_id = 30
ORDER BY last_name;

-- Zadatak 6
SELECT salary AS "mjesecna plata",
       first_name AS "ime zaposlenog",
       last_name AS "prezime zaposlenog",
       commission_pct AS "dodatak na platu"
FROM employees
WHERE salary > 1500 AND
      (department_id = 10 OR department_id = 30);
      
-- Zadatak 7
SELECT *
FROM employees
WHERE hire_date < TO_DATE('01-01-1996', 'DD-MM-YYYY');

-- Zadatak 8
SELECT e.first_name || ' ' || e.last_name AS Naziv,
       e.salary AS Plata,
       j.job_title AS Posao
FROM employees e, jobs j
WHERE manager_id IS NULL AND
    e.job_id = j.job_id;
    
-- Zadatak 9
SELECT first_name || ' ' || last_name AS Naziv,
       salary AS Plata,
       commission_pct AS "DODATAK NA PLATU"
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary, commission_pct;

-- Zadatak 10
SELECT first_name || ' ' || last_name AS Naziv
FROM employees
WHERE UPPER(first_name || last_name) LIKE '%I%I%';

-- Zadatak 11
SELECT first_name || ' ' || last_name AS Naziv,
       salary AS Plata,
       commission_pct AS "DODATAK NA PLATU"
FROM employees
WHERE NVL(commission_pct, 0) > 0.2;

