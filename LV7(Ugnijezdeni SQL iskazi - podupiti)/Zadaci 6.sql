SELECT * 
FROM employees
WHERE employee_id IN (SELECT employee_id
						  FROM employees 
						  WHERE manager_id IS NULL);

-- Zadatak 1
/*
Napisati upit koji će prikazati naziv zaposlenog, naziv odjela i naziv posla za sve
zaposlene koji rade u istom odjelu kao i Susan, isključujući Susan.
*/
SELECT e.first_name || ' ' || e.last_name naziv,
	   d.department_id naziv_odjela,
	   j.job_title naziv_posla
FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN jobs j ON e.job_id = j.job_id
WHERE e.department_id = (SELECT department_id
					   FROM employees
					   WHERE first_name = 'Susan')
AND e.first_name <> 'Susan';

SELECT * FROM employees WHERE department_id = 40;

-- Zadatak 2
/*
Napisati upit koji će prikazati šifru, ime, prezime, platu za sve zaposlene koji
zarađuju platu veću od prosječne plate svih zaposlenih iz odjela 30 i 90. 
*/
SELECT e.employee_id sifra,
	   e.first_name ime,
	   e.last_name prezime,
	   e.salary plata
FROM employees e
WHERE e.salary > (SELECT avg(e1.salary)
				  FROM employees e1
				  WHERE department_id IN (30, 90));

-- Zadatak 3
/*
Napisati upit koji će prikazati sve podatke o zaposlenim za sve zaposlene koji rade u
istom odjelu kao i neki od zaposlenih koji u imenu, na bilo kom mjestu, sadrže slovo
«C».
*/
SELECT *
FROM employees e
WHERE e.department_id IN (SELECT e1.department_id
						  FROM employees e1
						  WHERE lower(e1.first_name) LIKE '%c%');

-- Zadatak 4
/*
Napisati upit koji će prikazati šifru i naziv zaposlenog, kao i naziv posla za sve
zaposlene koji rade u odjelu koji je locairan u Torontu. 
*/
SELECT e.employee_id sifra,
	   e.first_name || ' ' || e.last_name naziv,
	   j.job_title naziv_posla
FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id
	JOIN jobs j ON e.job_id = j.job_id
WHERE l.city = 'Toronto';

SELECT e.employee_id sifra,
	   e.first_name || ' ' || e.last_name naziv,
	   j.job_title naziv_posla
FROM employees e
	JOIN jobs j ON e.job_id = j.job_id
WHERE e.department_id IN (SELECT d1.department_id
						  FROM departments d1 
						  	JOIN locations l ON d1.location_id = l.location_id
						  WHERE l.city = 'Toronto');



SELECT * FROM departments;
SELECT * FROM locations;
SELECT * FROM employees WHERE department_id = 20;

-- Zadatak 5
/*
Napisati upit koji će prikazati sve podatke o zaposlenim koji izvještavaju King-a.
*/
SELECT * 
FROM employees
WHERE manager_id IN (SELECT e.employee_id
					  FROM employees e
					  WHERE e.last_name = 'King');

-- Zadatak 6
/*
Modificirati upit pod rednim brojem 3 tako da prikazuje samo one zaposlene koji
dobivaju platu veću od prosječne plate svih zaposlenih iz dotičnog odjela u kojem
dati zaposlenik radi.
*/
SELECT *
FROM employees e
WHERE e.department_id IN (SELECT e1.department_id
						  FROM employees e1
						  WHERE lower(e1.first_name) LIKE '%c%'
						  AND e.salary > (SELECT avg(e2.salary)
										  FROM employees e2
										  WHERE e2.department_id = e1.department_id));

SELECT department_id,
	   avg(salary)
FROM employees 
GROUP BY department_id;

-- Zadatak 7
/*
Napisati upit koji će prikazati naziv zaposlenog, naziv odjela i platu za sve one
zaposlene koji pripadaju istom odjelu i zarađuju istu platu kao i neki od zaposlenih
koji dobiva dodatak na platu, isključujući one zaposlene koji dobivaju dodatak na
platu.
*/
SELECT e.first_name || ' ' || e.last_name naziv,
	   d.department_name naziv_odjela,
	   e.salary plata
FROM employees e
	JOIN departments d ON e.department_id = d.department_id
WHERE (e.department_id, e.salary) IN (SELECT e1.department_id, e1.salary*(1+e1.commission_pct)
									  FROM employees e1
									  WHERE e1.commission_pct IS NOT NULL)
AND e.commission_pct IS NULL;


SELECT e1.department_id, e1.salary*(1+e1.commission_pct)
FROM employees e1 
WHERE e1.commission_pct IS NOT NULL;


-- Zadatak 8
/*
Napisati upit koji će prikazati naziv zaposlenog, naziv odjela, platu i grad za svakog
zaposlenog koji ima istu platu i dodatak na platu kao i neki od zaposlenih koji rade
u Rimu.
*/
SELECT e.first_name || ' ' || e.last_name naziv_zaposlenog,
	   d.department_name naziv_odjela,
	   e.salary plata,
	   l.city grad
FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id
WHERE (e.salary, nvl(e.commission_pct, 0)) IN (SELECT e1.salary, nvl(e1.commission_pct, 0)
										      FROM employees e1
												JOIN departments d1 ON e1.department_id = d1.department_id
												JOIN locations l1 ON d1.location_id = l1.location_id
											  WHERE l1.city = 'Roma');


SELECT * FROM locations;
SELECT * FROM departments;

-- Zadatak 9
/*
Napisati upit koji će prikazati naziv zaposlenog, datum zaposlenja i platu za sve
zaposlene koji imaju istu platu i dodatak na platu kao i Scott.
*/
SELECT e.first_name || ' ' || e.last_name naziv_zaposlenog,
	   e.hire_date datum_zaposlenja,
	   e.salary
FROM employees e
WHERE (e.salary, nvl(e.commission_pct, 0)) IN (SELECT e1.salary, nvl(e1.commission_pct, 0)
											   FROM employees e1
											   WHERE e1.first_name = 'Scott');

SELECT e1.salary, nvl(e1.commission_pct, 0) 
FROM employees e1
WHERE e1.last_name = 'Scott';

SELECT e1.salary, nvl(e1.commission_pct, 0) 
FROM employees e1
WHERE e1.first_name = 'Scott';

-- Zadatak 10
/*
Napisati upit koji će prikazati samo one zaposlene koji zarađuju platu veću od plate
svih iz odjala za prodaju. Rezultat sortirati po plati od najveće do najmanje.
*/
SELECT *
FROM employees e
WHERE e.salary > ALL (SELECT e1.salary
					FROM employees e1
						JOIN departments d1 ON e1.department_id = d1.department_id
					WHERE d1.department_name = 'Sales')
ORDER BY e.salary desc;

SELECT * 
FROM employees e
WHERE e.salary > (SELECT max(e1.salary)
				  FROM employees e1 
				  	JOIN departments d1 ON e1.department_id = d1.department_id
				  WHERE d1.department_name = 'Sales');

SELECT * FROM departments;

-- Zadatak 11
/*
Napisati upit koji će prikazati naziv zaposlenog, naziv odjela, naziv posla i grad za
sve zaposlene koji primaju platu veću od prosjećne plate svojih svih šefova koji
imaju dodatak na platu i rade u istom odjelu kao i dotični zaposlenik.
*/
SELECT e.first_name || ' ' || e.last_name naziv_zaposlenog,
	   d.department_name naziv_odjela,
	   j.job_title posao,
	   l.city grad
FROM employees e 
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id
	JOIN jobs j ON e.job_id = j.job_id
WHERE e.salary > (SELECT avg(m.salary)
			      FROM employees m
				  WHERE m.department_id = e.department_id
				  AND m.commission_pct IS NOT NULL
				  AND m.employee_id IN (SELECT DISTINCT manager_id
										FROM employees 
										WHERE manager_id IS NOT NULL));	


-- Zadatak 12
/*
Napisati upit koji će prikazati šifru i naziv zaposlenog, šifru i naziv odjela, platu,
prosječnu, minimalnu i maksimalnu platu odjela u kojem zaposlenik radi, kao i
minimalnu, maksimalnu i prosječnu platu na nivou firme za sve zaposlene koji
imaju platu veću od minimalne prosječne plate svih šefova u odjelu u kojim dati
zaposlenik radi.
*/
SELECT e.employee_id,
	   e.first_name || ' ' || e.last_name,
	   d.department_id,
	   d.department_name,
	   e.salary,
	   round(platedep.PROSODJ, 2),
	   round(platedep.minodj, 2),
	   round(platedep.maxodj , 2),
	   round(platefir.prosfir , 2),
	   round(platefir.minfir , 2),
	   round(platefir.maxfir , 2)
FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN (SELECT d1.department_id depid, avg(e1.salary) prosodj, min(e1.salary) minodj, max(e1.salary) maxodj
		  FROM employees e1 
			JOIN departments d1 ON e1.department_id = d1.department_id
		  GROUP BY d1.department_id) platedep ON d.department_id = platedep.depid,
	(SELECT avg(e2.salary) prosfir, min(e2.salary) minfir, max(e2.salary) maxfir
	 FROM employees e2) platefir
WHERE e.salary > (SELECT avg(e3.salary)
				  FROM employees e3
				  WHERE e3.employee_id IN (SELECT DISTINCT manager_id
										   FROM employees 
			 							   WHERE manager_id IS NOT NULL)
				  AND e3.department_id = e.department_id);


SELECT *
FROM employees;














