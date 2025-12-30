--Zadatak 1
/*
Kreirajte vašu tabelu zaposlenih, sa analognim podacima kao i tabela employees,
gdje će te dodati novu kolonu «id» nad kojom će biti definisan primary key.
Odaberite adekvatan tip podataka «id» kolone prema planiranim i/ili ubačenim
vrijednostima.
*/
-- moze se pri kreaciji tabele dodati nova kolona id koja ce imati vrijednost neke sekvence za svaki red
CREATE TABLE zaposleni 
AS 
SELECT *
FROM employees
WHERE 1=0;

ALTER TABLE zaposleni 
ADD id NUMBER(10);

ALTER TABLE zaposleni 
ADD CONSTRAINT c_tab_zap_PK PRIMARY KEY (id);

COMMIT;


SELECT * FROM zaposleni;
DROP TABLE zaposleni;
SELECT * FROM employees;
SELECT * FROM user_tables;
SELECT * FROM test1;
DROP TABLE test1;

--Zadatak 2
/* 
Kreirajte vašu tabelu odjela, sa analognim podacima kao i tabela departments, gdje
će te dodati nove kolone «id i datum» nad kojom će biti definisan primary key.
Odaberite adekvatne tipove podataka za naznačene kolone.
*/
CREATE TABLE odjel
AS 
SELECT * 
FROM departments 
WHERE 1 = 0;

ALTER TABLE odjel
ADD (
	id NUMBER(10),
	datum DATE,
	CONSTRAINT c_tab_odjl_PK PRIMARY KEY (id, datum)
);

SELECT * FROM odjel;

--Zadatak 3 
/* 
Re-dizajnirajte vašu tabelu zaposlenih tako da je moguće kreirati foreign key
između vaše tabele zaposlenih i odjela. Neophodno je ažurirati sve slogove tabele
zaposlenih kako bi se prenijele potrebne informacije iz vaše table odjela u vašu
tabelu zaposlenih.
*/
ALTER TABLE zaposleni 
ADD (
	odjel_id NUMBER(10),
	odjel_datum DATE,
	CONSTRAINT c_tab_zap_FK FOREIGN KEY (odjel_id, odjel_datum)
	REFERENCES odjel (id, datum)
);

SELECT * FROM zaposleni;


--Zadatak 4 
/*
Provjerite koji sve constraint-i postoje nad vašom šemom baze potom nad šemom
«hr», a potom nad šemom «test». Da li svaka tabela u šemi «hr» posjeduje primary key?
*/
SELECT * 
FROM all_constraints
WHERE owner IN ('AP19387', 'HR', 'TEST');

SELECT * 
FROM all_constraints 
WHERE owner = 'HR' AND 
	constraint_type = 'P';
-- DA

--Zadatak 5
/*
Prikažite sve objekte koji imaju neke veze sa tabelom EMPLOYEES i DEPARTMENTS
iz šeme «hr».
*/
SELECT a.constraint_name, 
	   a.table_name,
	   a.constraint_type,
	   b.constraint_name,
	   b.table_name
FROM all_constraints a 
	JOIN all_constraints b ON a.r_constraint_name = b.constraint_name
WHERE a.owner = 'HR' AND 
	a.table_name IN ('EMPLOYEES', 'DEPARTMENTS') AND 
	a.constraint_type = 'R';

--Zadatak 6
/*
Modificirajte tabelu zaposlenih tako što će te dodati novu kolonu plata_dodatak koji
će sadržavati platu uvećanu za dodatak na platu samo za zaposlene iz Amerike.
*/
ALTER TABLE zaposleni  
ADD (
	plata_dodatak NUMBER(10,2)
);

SELECT * FROM zaposleni;
SELECT * FROM employees;
SELECT * FROM locations;

--Zadatak 7
/*
Dodajte CHECK constraint za kolonu kreiranu u 6 zadatku za razuman raspon
vrijednosti.
*/
ALTER TABLE zaposleni 
ADD CONSTRAINT c_tab_zap_CHK CHECK (plata_dodatak BETWEEN 2000 AND 25000);

SELECT * FROM user_constraints;

--Zadatak 8
/*
Kreirajte pogled sa nazivom zap_pog sa sljedećim kolonama: šifra zaposlenog,
naziv zaposlenog i naziv odjela, za sve zaposlene koji primaju platu veću od
prosječne plate odjela u kojem rade.
*/
CREATE VIEW zap_pog  
AS 
SELECT e.employee_id sifra_zaposlenog,  
	e.first_name || ' ' || e.last_name naziv_zaposlenog,
	d.department_name naziv_odjela
FROM employees e 
	JOIN departments d ON e.department_id = d.department_id 
WHERE e.salary > (SELECT avg(e1.salary)
				  FROM employees e1  
				  WHERE e1.department_id = e.department_id);

SELECT * 
FROM zap_pog;

--Zadatak 9
/*
Prikažite sadržaj kreiranog pogleda. Da li je moguće kombinovati poglede s
osnovnim tabelama baze.
*/
-- da, ali za ovaj primjer je limitirano
SELECT *
FROM zap_pog pz 
	JOIN departments d ON pz.naziv_odjela = d.department_name;

--Zadatak 10
/*
Kreirajte pogled koji će vratit naziv posla, naziv odjela, prosječnu platu i iznos
dodataka na platu po datim poslovima i odjelima za sve poslove i odjele koji u
imenu sadrže slova «a», «b», i «c» na bilo kojoj poziciji. Pogled se može koristiti
samo za pregled.
*/
CREATE VIEW zad_deset_lab_osam
AS 
SELECT j1.job_title posao, 
	d1.department_name odjel, 
	avg(e1.salary) prosjecna_plata, 
	avg(nvl(e1.commission_pct, 0)) prosjecni_dodatak
FROM employees e1 
	JOIN jobs j1 ON j1.job_id = e1.job_id 
	JOIN departments d1 ON d1.department_id = e1.department_id
WHERE (lower(d1.department_name) LIKE '%a%'
	OR lower(d1.department_name)  LIKE '%b%'
	OR lower(d1.department_name)  LIKE '%c%')
GROUP BY j1.job_title, d1.department_name
WITH READ ONLY;

SELECT * 
FROM zad_deset_lab_osam;

--Zadatak 11
/*
Modificirajte predhodni pogled tako da uvedete novu kolonu koja će sadržavati
prosječnu platu po odjelima.
*/
CREATE OR REPLACE VIEW zad_deset_lab_osam
AS 
SELECT j1.job_title posao, 
	d1.department_name odjel, 
	avg(e1.salary) prosjecna_plata, 
	avg(nvl(e1.commission_pct, 0)) prosjecni_dodatak,
	prosj.plata_po_odjelu prosjecna_plata_po_odjelu
FROM employees e1 
	JOIN jobs j1 ON j1.job_id = e1.job_id 
	JOIN departments d1 ON d1.department_id = e1.department_id
	JOIN (SELECT d2.department_id sifra_odjela, avg(e2.salary) plata_po_odjelu
		  FROM employees e2 JOIN departments d2 ON e2.department_id = d2.department_id
		  GROUP BY d2.department_id) prosj ON prosj.sifra_odjela = d1.department_id
WHERE (lower(d1.department_name) LIKE '%a%'
	OR lower(d1.department_name)  LIKE '%b%'
	OR lower(d1.department_name)  LIKE '%c%')
GROUP BY j1.job_title, d1.department_name, prosj.plata_po_odjelu
WITH READ ONLY;

SELECT * 
FROM zad_deset_lab_osam;

























