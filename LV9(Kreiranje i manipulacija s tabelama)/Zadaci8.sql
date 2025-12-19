--Zadatak 1
/*
Kreirati tabelu odjela sa sljedećom strukturom:
*/
CREATE TABLE odjeli(Id varchar2(25) NOT NULL,
		 			Naziv varchar2(10) NOT NULL,
		 			Opis char(15),
		 			Datum DATE NOT NULL,
		 			Korisnik varchar2(30) NOT NULL,
					Napomena varchar2(10));

--Zadatak 2
/*
Kopirate podatke iz tabele odjela u vašu kreiranu tabelu odjela samo onim
podacima koje je moguće upisati u tabelu.
*/
INSERT INTO odjeli(id, naziv)
SELECT department_id, department_name 
FROM departments;

SELECT * FROM departments;

--Zadatak 3
/*
Modificirati vašu tabelu odjela na takav način da se upišu svi podaci iz postojeće
tabele odjela.
*/
ALTER TABLE odjeli ADD (menadzer_id NUMBER(6, 0), lokacija_id NUMBER(4, 0));

SELECT * FROM odjeli;

--Zadatak 4
/*
Kreiraje vašu tabelu zaposlenih sa sljedećom strukturom:
*/
CREATE TABLE zaposlenici (Id NUMBER(4) NOT NULL,
                          Sifra_zaposlenog VARCHAR2(5) NOT NULL,
                          Naziv_zaposlenog CHAR(50),
                          Godina_zaposlenja NUMBER(4) NOT NULL,
                          Mjesec_zaposlenja CHAR(2) NOT NULL,
                          Sifra_odjela VARCHAR2(5),
                          Naziv_odjela VARCHAR2(15) NOT NULL,
                          Grad CHAR(10) NOT NULL,
                          Sifra_posla VARCHAR2(25),
                          Naziv_posla CHAR(50) NOT NULL,
                          Iznos_dodatak_na_platu NUMBER(5),
                          Plata NUMBER(6) NOT NULL,
                          Kontinent VARCHAR2(20),
                          Datum_unosa DATE NOT NULL,
                          Korisnik_unio CHAR(20) NOT NULL);



SELECT * FROM zaposlenici;

--Zadatak 5
/*
Na  sve postojeće podatke o zaposlenim iz tabla vezanih za zaposlene, kopirajte
potrebne podatke u vašu tabelu zaposlenih.
*/
CREATE SEQUENCE zaposlnici_seq 
START WITH 1
INCREMENT BY 1 
NOCACHE 
NOCYCLE;
INSERT INTO zaposlenici (
    Id,
    Sifra_zaposlenog,
    Naziv_zaposlenog,
    Godina_zaposlenja,
    Mjesec_zaposlenja,
    Sifra_odjela,
    Naziv_odjela,
    Grad,
    Sifra_posla,
    Naziv_posla,
    Iznos_dodatak_na_platu,
    Plata,
    Kontinent,
    Datum_unosa,
    Korisnik_unio
)
SELECT zaposlnici_seq.nextval,
	   e.employee_id,
	   e.first_name || ' ' || e.last_name,
	   to_number(to_char(hire_date, 'yyyy')),
	   to_char(hire_date, 'mm'),
	   to_char(d.department_id),
	   d.department_name,
	   l.city,
	   e.job_id,
	   j.job_title,
	   e.commission_pct,
	   e.salary,
	   r.region_name,
	   sysdate,
	   USER
FROM employees e 
	JOIN jobs j ON e.job_id = j.job_id  
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id 
	JOIN countries c ON l.country_id = c.country_id
	JOIN regions r ON c.region_id = r.region_id,
	dual;
	   
SELECT * FROM regions;
SELECT USER FROM dual;


SELECT e.employee_id,
	   e.first_name || ' ' || e.last_name,
	   to_number(to_char(hire_date, 'yyyy')),
	   to_char(hire_date, 'mm'),
	   to_char(d.department_id),
	   d.department_name,
	   l.city,
	   e.job_id,
	   j.job_title,
	   e.commission_pct,
	   e.salary,
	   r.region_name,
	   sysdate,
	   USER
FROM employees e 
	LEFT JOIN jobs j ON e.job_id = j.job_id  
	LEFT JOIN departments d ON e.department_id = d.department_id
	LEFT JOIN locations l ON d.location_id = l.location_id 
	LEFT JOIN countries c ON l.country_id = c.country_id
	JOIN regions r ON c.region_id = r.region_id,
	dual;
	   

SELECT * FROM locations;
SELECT * FROM countries;



























