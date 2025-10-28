SELECT *
FROM employees
WHERE last_name = 'Russell';



-- Zadatak 1
/*
Napisati upit koji će prikazati naziv zaposlenog , šifru i naziv odjela za sve
zaposlene.
*/
SELECT e.first_name || ' ' || e.last_name AS naziv,
       e.department_id AS "SIFRA ODJELA",
       d.department_name AS "NAZIV ODJELA"
FROM employees e LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id;


-- Zadatak 2
/*
Napisati jedinstvenu listu svih poslova iz odjela 30.
*/
SELECT DISTINCT j.job_title AS posao
FROM employees e NATURAL JOIN jobs j;


-- Zadatak 3
/*
Napisati upit koji će prikazati naziv zaposlenog, naziv odjela i lokaciju za sve
zaposlene koji ne primaju dodataka na platu.
*/
SELECT e.first_name || ' ' || e.last_name AS naziv,
       d.department_name AS "NAZIV ODJELA",
       l.city AS lokacija
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE e.commission_pct IS NULL;


-- Zadatak 4
/*
Napisati upit koji će prikazati naziv zaposlenog i naziv odjela za sve zaposlene koji u
imenu sadrže slovo A na bilo kom mjestu.
*/
SELECT e.first_name || ' ' || e.last_name AS naziv,
       d.department_name AS "NAZIV ODJELA"
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
WHERE UPPER(e.first_name) LIKE '%A%';


-- Zadatak 5
/*
Napisati upit koji će prikazati naziv, posao, broj i naziv odjela za sve zaposlene koji
rade u DALLAS-u.
*/
SELECT e.first_name || ' ' || e.last_name AS naziv,
       j.job_title AS posao,
       d.department_id AS "BROJ ODJELA",
       d.department_name AS "NAZIV ODJELA"
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    NATURAL JOIN jobs j
WHERE l.city = 'Dallas';

-- Pomoc za ovaj zad
SELECT *
FROM locations /*WHERE city = 'Dallas'*/;


-- Zadatak 6
/*
Napisati upit koji će prikazati naziv zaposlenog, naziv šefa i grad šefa u kojem radi.
Za labele kolona uzeti Naziv zaposlenog, Šifra zaposlenog, Naziv šefa, Šifra šefa,
Grad šefa, respektivno.
*/
SELECT e.first_name || ' ' || e.last_name AS "Naziv zaposlenog",
       e.employee_id AS "Sifra zaposlenog",
       m.first_name || ' ' || m.last_name AS "Naziv sefa",
       m.employee_id AS "Sifra zaposlenog",
       ml.city AS "Grad sefa"
FROM employees e 
    JOIN employees m ON e.manager_id = m.employee_id
    JOIN departments md ON m.department_id = md.department_id
    JOIN locations ml ON md.location_id = ml.location_id;


-- Zadatak 7
/*
Modificirati upit pod rednim brojem šest, da prikazuje i manager-a King-a koji nema
predpostavljenog.
*/
SELECT e.first_name || ' ' || e.last_name AS "Naziv zaposlenog",
       e.employee_id AS "Sifra zaposlenog",
       m.first_name || ' ' || m.last_name AS "Naziv sefa",
       m.employee_id AS "Sifra zaposlenog",
       ml.city AS "Grad sefa"
FROM employees e 
    LEFT OUTER JOIN employees m ON e.manager_id = m.employee_id
    LEFT OUTER JOIN departments md ON m.department_id = md.department_id
    LEFT OUTER JOIN locations ml ON md.location_id = ml.location_id;
    
    
-- Zadatak 8
/*
Napisati upit koji će prikazati naziv zaposlenog, šifru odjela, i sve zaposlene koji
rade u istom odjelu kao i uzeti zaposlenik. Za kolone uzeti odgovarajuće labele.
*/
SELECT e1.first_name || ' ' || e1.last_name AS naziv,
       e1.department_id AS "SIFRA ODJELA",
       e2.first_name || ' ' || e2.last_name AS "NAZIV KOLEGE U ISTOM ODJELU"
FROM employees e1 
    JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.employee_id <> e2.employee_id
ORDER BY e1.department_id, e1.employee_id;


-- Zadatak 9
/*
Napisati upit koji će prikazati naziv, posao, naziv odjela, platu i stepene plate za sve
zaposlene kod kojih stepen plate nije u rasponu kada se na platu zaposlenog doda
dodatak na platu.
*/
SELECT e.first_name || ' ' || e.last_name AS naziv,
       j.job_title AS posao,
       d.department_name AS "NAZIV ODJELA",
       e.salary AS plata,
       j.min_salary AS "MIN PLATA",
       j.max_salary AS "MAX PLATA"
FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
    JOIN jobs j ON e.job_id = j.job_id
WHERE e.salary*(1+NVL(e.commission_pct, 0)) NOT BETWEEN j.min_salary AND j.max_salary;


-- Zadatak 10
/*
Napisati upit koji će prikazati naziv i datum zaposlenja za sve radnike koji su
zaposeleni poslije Blake-a.
*/
SELECT e1.first_name || ' ' || e1.last_name AS naziv,
       e1.hire_date AS "DATUM ZAPOSLENJA"
FROM employees e1
    JOIN employees e2 ON e1.hire_date > e2.hire_date
WHERE e2.last_name = 'Blake'
ORDER BY e1.hire_date;

-- Pomoc za zad
SELECT * 
FROM employees
WHERE last_name = 'Blake';


-- Zadatak 11
/*
Napisati upit koji će prikazati naziv i datum zaposlenja zaposlenog, naziv i datum
zaposlenja šefa zaposlenog, za sve zaposlene koji su se zaposlili prije svog šefa.
*/
SELECT e.first_name || ' ' || e.last_name AS "Naziv zaposlenog",
       e.hire_date AS "Datum zaposlenja (zaposleni)",
       m.first_name || ' ' || m.last_name AS "Naziv sefa",
       m.hire_date AS "Datum zaposlenja (sef)"
FROM employees e 
    JOIN employees M ON e.manager_id = m.employee_id
WHERE e.hire_date < m.hire_date;




