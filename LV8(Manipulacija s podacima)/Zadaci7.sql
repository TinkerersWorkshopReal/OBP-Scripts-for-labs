--Zadatak 1
/*
Kreirati tabelu zaposlenih u okviru šeme baze na koju ste trenutno logirani. Za
naziv tabele koriste slovo «z» i broj vašeg indeksa (na primjer z14004):
CREATE TABLE z14004 AS SELECT * from employees;
*/
CREATE TABLE z19387 
AS SELECT * 
   FROM employees;

COMMIT;

--Zadatak 2
/*
Opišite strukturu vaše tabele i identifirajte nazive kolona. Da li postoje neka
ograničenja vezana za pojedine kolone tabele? Ako postoje koja su, ako ne zašto ne
postoje?
*/
SELECT *
FROM all_tab_columns
WHERE table_name = 'Z19387';


--Zadatak 3
/*
U vašu tabelu zaposlenih dodajte 5 novih slogova za odjel marketinga i šefom sa
šifrom 100.
*/
INSERT ALL
	INTO z19387 VALUES (207, 'Mark', 'Dark', 'MDARK', '123.423.3214', to_date('2005-06-04', 'yyyy-mm-dd'), 'MK_MAN', 10001, NULL, 100, 20)
	INTO z19387 VALUES (208, 'Mark', 'Clark', 'MCLARK', '122.423.8658', to_date('2004-06-04', 'yyyy-mm-dd'), 'MK_MAN', 10002, NULL, 100, 20)
	INTO z19387 VALUES (209, 'Mark', 'Tart', 'MTART', '127.423.3767', to_date('2003-06-04', 'yyyy-mm-dd'), 'MK_MAN', 10003, NULL, 100, 20)
	INTO z19387 VALUES (210, 'Mark', 'Smart', 'MSMART', '128.423.6345', to_date('2002-06-04', 'yyyy-mm-dd'), 'MK_MAN', 10004, NULL, 100, 20)
	INTO z19387 VALUES (211, 'Mark', 'Dart', 'MDART', '126.423.1783', to_date('2001-06-04', 'yyyy-mm-dd'), 'MK_MAN', 10005, NULL, 100, 20)
SELECT 1 FROM dual;


SELECT * FROM z19387 ORDER BY 1;
SELECT * FROM departments;
SELECT * FROM jobs;

--Zadatak 4
/*
Promijenite dodatak na platu za sve one zaposlene koji imaju platu manju od 3000
KM.
*/
UPDATE z19387
	SET commission_pct = 0.8
WHERE salary < 3000;


--Zadatak 5
/*
Promijenite platu za sve one zapslene koji rade u New Yorku tako da im je plata
uvećana za dodatak na platu ako ga imaju, a ako ne onda smanjiti platu za 10% i
dodatak na platu uvećati za 15%.
*/
UPDATE z19387 z1
	SET (z1.salary, z1.commission_pct) = (SELECT decode(nvl(z2.commission_pct, 0),
							    		  			    0, z2.salary*0.9,
							    		  			    z2.salary*(1+z2.commission_pct)),
							    		  		 decode(nvl(z2.commission_pct, 0),
							    		  			    0, z2.commission_pct*1.15,
							    		  			    z2.commission_pct)
			      						  FROM z19387 z2
			      						  WHERE z1.employee_id = z2.employee_id)
WHERE z1.department_id = (SELECT d.department_id
						  FROM departments d
			      		   		JOIN locations l ON d.location_id = l.location_id
						  WHERE l.city = 'New York');


SELECT *
FROM z19387 z
	JOIN departments d ON z.department_id = d.department_id
WHERE d.department_name = 'Marketing';

SELECT * FROM locations ORDER BY 4;

--Zadatak 6
/*
Modificirati šifru odjela za sve one zaposlene, u vašoj tabeli zaposlenih, koji rade u
Americi i imaju platu manju od prosječne plate svih zaposlenih u dotičnom odjelu,
osim datog zaposlenog, tako da pripada odjelu Makretinga, i nemaju platu jednaku
minimalnoj i maksimalnoj plati na nivou svih organizacijskih jednica.
*/
UPDATE z19387 z1
SET z1.department_id = (SELECT d.department_id
			    	 	FROM departments d
			    	 	WHERE d.department_name = 'Marketing')
WHERE z1.department_id IN (SELECT d.department_id 
						  FROM departments d 
						  	JOIN locations l ON d.location_id = l.location_id
						  WHERE l.country_id = 'US')
AND z1.salary < (SELECT avg(z2.salary)
				 FROM z19387 z2 
				 WHERE z2.employee_id <> z1.employee_id
	     		 AND z2.department_id = z1.department_id)
AND z1.salary <> (SELECT max(z2.salary)
				  FROM z19387 z2)
AND z1.salary <> (SELECT min(z2.salary)
				  FROM z19387 z2);


--Zadatak 7
/*
Modificirati šifru šefa, u vašoj tabeli zaposlenih, za sve one zaposlene koji su
nadređeni onim šefovima koji posjeduju veći broj zaposlenih od prosječnog broja
zaposlenih kod svih preostalih šefova, onom šefu koji posjeduje minimalan broj
zaposlenih.
*/
UPDATE z19387 z1
SET z1.manager_id = (SELECT manager_id
				  	 FROM (SELECT manager_id,
					   		   	  count(*)
					       FROM Z19387
					       WHERE manager_id IS NOT NULL 
					       GROUP BY manager_id  
					       HAVING count(*) = (SELECT min(count(*))
									       	  FROM Z19387 
								  	          WHERE manager_id IS NOT NULL 
									          GROUP BY manager_id)
					       ORDER BY 1 ASC)
				     WHERE rownum = 1)
WHERE z1.manager_id IN (SELECT man 
					   FROM (SELECT z2.manager_id man, 
					         		count(*)
					         FROM z19387 z2 
					         WHERE z2.manager_id IS NOT NULL
					         GROUP BY z2.manager_id 
					         HAVING count(*) > (SELECT avg(count(*))
					         	      		    FROM z19387 z3 
					         	      		    WHERE z3.manager_id IS NOT NULL
					         	      		    	AND z3.manager_id <> z2.manager_id
					         	      		    GROUP BY manager_id)));
					         	      		    
			
SELECT employee_id, manager_id  
FROM z19387 
ORDER BY 1;

SELECT manager_id, 
	   count(*) 
FROM z19387 
WHERE manager_id IS NOT NULL  
GROUP BY manager_id
ORDER BY 2 DESC;


SELECT z1.manager_id,
	   count(*)
FROM z19387 z1 
WHERE z1.manager_id IS NOT NULL 
GROUP BY z1.manager_id 
HAVING count(*) > (SELECT avg(count(*))
				   FROM Z19387 z2 
				   WHERE z2.manager_id IS NOT NULL
				   GROUP BY z2.manager_id);

SELECT manager_id,
					   		   	  nvl(count(*), 0)
					       FROM Z19387
					       WHERE manager_id IS NOT NULL 
					       GROUP BY manager_id  
					       HAVING count(*) = (SELECT min(count(*))
									       	  FROM Z19387 
								  	          WHERE manager_id IS NOT NULL 
									          GROUP BY manager_id)
					       ORDER BY 1 ASC;


SELECT (60*32)
FROM dual;


--Zadatak 8
/*
Na osnovu prvog primjera kreirati file koji sadrži komande za kreiranje nove vaše
tabele odjela koja će se zvati slično kao tabela u prvom primjeru, samo što će se
umjesto slova «z» sada koristiti slovo «o» i broj vašeg indeksa.
*/
CREATE TABLE o19387 
AS SELECT * FROM departments;

COMMIT;


SELECT table_name
FROM user_tables;

--Zadatak 9
/*
Modificirati sve nazive odjela, u vašoj tabeli odjela, tako što će te ispred imena
odjela staviti «US -», ako se odjel nalazi u Americi, u protivnom staviti «OS -» za
sve ostale odjele.
*/
UPDATE o19387 o
SET o.department_name = (SELECT decode(l.country_id,
									   'US', 'US -' || d.department_name,
									   'OS -' || d.department_name)
				   	 	 FROM locations l
				   	 	 WHERE l.location_id = o.location_id);
				   	 	 	
SELECT * FROM o19387; 	
SELECT * FROM locations;

--Zadatak 10
/*
Iz vaše tabele zaposlenih izbrisati sve one zaposlene koji rade u onim odjelima koji
u imenu sadrže, na bilo kojoj poziciji, slovo 'a' ili 'A'.
*/
DELETE FROM Z19387 z
WHERE EXISTS (SELECT 1
			  FROM o19387 o1
			  WHERE z.department_id = o1.department_id  
			  AND lower(o1.department_name) LIKE '%a%');


SELECT department_id, first_name, last_name 
FROM z19387;

SELECT * FROM o19387;

--Zadatak 11
/*
Iz tabele odjela izbrisati sve odjele u kojim ne radi ni jedan zaposlenik.
*/
DELETE FROM o19387 o
WHERE NOT EXISTS (SELECT 1
				  FROM z19387 z1 
				  WHERE z1.department_id = o.department_id);
				  
				  
SELECT o.department_name, count(z.employee_id)
FROM o19387 o 
	LEFT JOIN z19387 z ON o.department_id = z.department_id 
GROUP BY o.department_name
HAVING count(z.EMPLOYEE_ID )= 0;

SELECT * FROM o19387;

SELECT *
				  FROM z19387 z1, o19387 o
				  WHERE z1.department_id = o.department_id;

--Zadatak 12
/*
Izbrisati sve one zaposlene, iz vaše tabele zaposlenih, koji ne rade u Aziji i imaju
šefa koji je nadređen bar trojici zaposlenih, i gdje taj šef ima šefa koji prima platu
veću od plate onog šefa koji u okviru firme ima minimalan broj zaposlenih kojim je
nadređen.
*/


































