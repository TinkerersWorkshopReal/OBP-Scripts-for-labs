SELECT *
FROM employees;


--Zadatak 1
/*
Napisati upit koji će prikazati sumu iznosa datataka na platu, broj zaposlenih koji
dobivaju dodatak na platu, kao i ukupan broj zaposlenih.
*/
SELECT sum(salary*nvl(commission_pct, 0)) suma_dodataka,
       count(commission_pct) broj_zaposlenih_sa_dodatkom,
       count(*) broj_zaposlenih
FROM employees;

--Zadatak 2
/*
Napisati upit koji će prikazati broj zaposlenih po poslovima i organizacionim
jedinicama. Za labele uzeti naziv posla, naziv organizacione jedinice i broj uposlenih
respektivno.
*/
SELECT j.job_title naziv_posla,
       d.department_name naziv_organizacione_jedinice,
       count(e.job_id)
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_title, d.department_name;

SELECT * 
FROM departments;

--Zadatak 3
/*
Napisati upit koji će prikazati najveću, najmanju, sumarnu i prosječnu platu za sve
zaposlene. Vrijednosti zaokružiti na šest decimalnih mjesta.
*/
SELECT to_char(round(max(salary), 6), 'FM99999999.000000') najveca_plata,
       to_char(round(min(salary), 6), 'FM99999999.000000') najmanja_plata,
       to_char(round(sum(salary), 6), 'FM99999999.000000') suma_plata,
       to_char(round(avg(salary), 6), 'FM99999999.000000') prosjecna_plata
FROM employees;

--Zadatak 4
/*
Modificirati prethodni upit tako da pokazuje maksimalnu, minimalnu i prosječnu
platu po poslovima.
*/
SELECT job_id sifra_posla,
       to_char(round(max(salary), 6), 'FM99999999.000000') najveca_plata,
       to_char(round(min(salary), 6), 'FM99999999.000000') najmanja_plata,
       to_char(round(avg(salary), 6), 'FM99999999.000000') prosjecna_plata
FROM employees
GROUP BY job_id;

--Zadatak 5
/*
Napisati upit koji će prikazati broj zaposlenih po poslovima.
*/
SELECT j.job_title naziv_posla,
       count(e.job_id) broj_zaposlenih
FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_title, e.job_id;

--Zadatak 6
/*
Napisati upit koji će prikazati broj menadžera, bez njihovog prikazivanja.
*/
SELECT count(DISTINCT manager_id)
FROM employees;

-- Pomoc za zadatak
SELECT DISTINCT manager_id
FROM employees;

--Zadatak 7
/*
Napisati upit koji će prikazati naziv menadžera i platu samo za one menadžere koji
u okviru date organizacione jedinice dobivaju minimalnu platu u odnosu na sve
ostale menadžere ostalih odjela.
What??? 
Upit ispod prikazuje naziv i platu menadzera samo ako taj menager ima minimalnu platu
u odnosu na ostale menadzera iz istog odjela
*/
SELECT m.first_name || ' ' || m.last_name naziv_menadzera,
       m.salary plata_menadzera
FROM employees e
    JOIN employees m ON e.manager_id = m.employee_id
WHERE m.salary = (SELECT min(m2.salary) 
                  FROM employees e2
                    JOIN employees m2 ON e2.manager_id = m2.employee_id
                  WHERE m2.department_id = m.department_id)
GROUP BY m.first_name || ' ' || m.last_name, m.salary;

--Zadatak 8
/*
Napisati upit koji će prikazati naziv odjela, naziv grada, broj zaposlenih i prosječnu
platu za sve zaposlene u dotičnom odjelu.
*/
SELECT d.department_name naziv_odjela,
       l.city naziv_grada,
       count(e.employee_id) broj_zaposlenih_za_odjel,
       round(avg(e.salary), 2) prosjecna_plata_za_odjela
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
GROUP BY d.department_name, l.city;


--Zadatak 9
/*
Napisati upit koji će prikazati broj zaposlnih koji su bili zaposleni u 1995, 1996,
1997 i 1998, kao i ukupan broj zaposlenih u ovim godinama. Za labele uzeti 1995g,
1996g, 1997g, 1998g i ukupan broj zaposlenih respektivno.
2,3,4,5
*/
WITH 
zap_2002 AS (
SELECT count(hire_date) broj_zap
FROM employees
WHERE to_char(hire_date, 'YYYY') = '2002'
),
zap_2003 AS (
SELECT count(hire_date) broj_zap
FROM employees
WHERE to_char(hire_date, 'YYYY') = '2003'
),
zap_2004 AS (
SELECT count(hire_date) broj_zap
FROM employees
WHERE to_char(hire_date, 'YYYY') = '2004'
),
zap_2005 AS (
SELECT count(hire_date) broj_zap
FROM employees
WHERE to_char(hire_date, 'YYYY') = '2005'
),
zap_ukupno AS (
SELECT count(hire_date) broj_zap
FROM employees
WHERE to_char(hire_date, 'YYYY') IN ('2002', '2003', '2004', '2005')
)
SELECT a2.broj_zap "2002g",
       a3.broj_zap "2003g",
       a4.broj_zap "2004g",
       a5.broj_zap "2005g",
       au.broj_zap "ukupan broj zaposlenih"
FROM zap_2002 a2, zap_2003 a3, zap_2004 a4, zap_2005 a5, zap_ukupno au;

--Drugi nacin
SELECT count(decode(to_char(hire_date, 'YYYY'), 2002, 1, NULL)) "2002g",
       count(decode(to_char(hire_date, 'YYYY'), 2003, 1, NULL)) "2003g", 
       count(decode(to_char(hire_date, 'YYYY'), 2004, 1, NULL)) "2004g",
       count(decode(to_char(hire_date, 'YYYY'), 2005, 1, NULL)) "2005g",
       count(decode(to_char(hire_date, 'YYYY'), 
                    2002, 5, 
                    2003, -32,
                    2004, 7,
                    2005, 9,
                          NULL)) "ukupan broj zaposlenih"
FROM employees;
/*
NOTE: count ce brojat red za bilo koji vrijednost osim NULL
*/


--Zadatak 10
/*
Napisati matrični izvještaj koji će prikazati naziv posla i sumarnu platu po odjelima,
kao i ukupnu platu po datim poslovima i odjelima. Za labele uzeti kao što je
prikazano na tabeli:
*/
SELECT j.job_title "Posao",
       (SELECT sum(salary) 
        FROM employees
        WHERE department_id = 10 
        AND job_id = j.job_id) "Odjel 10",
       (SELECT sum(salary) 
        FROM employees
        WHERE department_id = 30 
        AND job_id = j.job_id) "Odjel 30",
       (SELECT sum(salary) 
        FROM employees
        WHERE department_id = 50 
        AND job_id = j.job_id) "Odjel 50",
       (SELECT sum(salary) 
        FROM employees
        WHERE department_id = 90 
        AND job_id = j.job_id) "Odjel 90",
       (SELECT sum(salary) 
        FROM employees
        WHERE department_id IN (10, 30, 50, 90)
        AND job_id = j.job_id) "Ukupno"
FROM jobs j;
        
       
















