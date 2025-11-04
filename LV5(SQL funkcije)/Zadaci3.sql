--Zadatak 1
/*
Napisati upit koji će prikazati trenutni datum i korisnika logiranog na bazu
podataka. Labele za kolone su date i user respektivno.
*/
SELECT sysdate "date",
       user "user"
FROM dual;

--Zadatak 2
/*
Napisati upit koji će prikazati šifru, ime, prezime, platu i platu uvećanu za 25% kao
cijeli broj. Labela za novu platu je «plata uvećana za 25%».
*/
SELECT employee_id sifra,
       first_name ime,
       last_name prezime,
       salary plata,
       trunc(salary*(1.25)) "plata uvećana za 25%"
FROM employees;

--Zadatak 3
/*
Modificirati upit 2 tako da se doda nova kolona koja će iz nove plata izdvojiti
posljednje 2 cifre plate i prikazati kao novu kolonu koja će se zvati «ostatak plate».
*/
SELECT employee_id sifra,
       first_name ime,
       last_name prezime,
       salary plata,
       trunc(salary*1.25) "plata uvećana za 25%",
       lpad(mod(salary*1.25, 100), 2,'0') "ostatak plate"
FROM employees;

--Zadatak 4
/*
Napisati upit koji će prikazati naziv zaposlenog, datum zaposlenja i datum prvog
ponedjeljka nakon 6 mjeseci rada zaposlenog. Datume predstaviti u formatu naziv
dana – naziv mjeseca, godina.
*/
SELECT first_name || ' ' || last_name naziv,
       to_char(hire_date, 'FMDAY-MONTH,YYYY') "DATUM ZAPOSLENJA",
       to_char(next_day(add_months(hire_date, 6), 'MONDAY'), 'FMDAY-MONTH,YYYY')
FROM employees;
       
--Zadatak 5
/*
Za sve zaposlene iz tabele zaposlenih prikazati naziv zaposlenog, naziv odjela i
kontinent, kao i broj mjeseci zaposlenja zaposlenika. Broj mjeseci zaokružiti na
cjelobrojnu vrijednost.
*/
SELECT e.first_name || ' ' || e.last_name naziv,
       d.department_name "NAZIV ODJELA",
       r.region_name kontinent,
       round(months_between(sysdate, hire_date), 0) "BROJ MJESECI ZAPOSLENOSTI"
FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    JOIN regions r ON c.region_id = r.region_id;
       
--Zadatak 6
/*
Napisati upit koji će prikazati za sve zaposlene iz odjela 10, 30 i 50 sljedeće:
«naziv zaposlenog» prima platu «iznos plate» mjesečno ali on bi želio platu «plata
uvećana za procenat dodataka na platu i pomnožena sa 4,5 puta». Labela za kolonu
je «plata o kojoj možeš samo sanjati».
*/
SELECT first_name || ' ' || last_name || ' prima platu ' 
       || salary || ' mjesecno ali on bi zelio platu ' 
       || (salary * (1 + nvl(commission_pct, 0)))*4.5 "plata o kojoj mozes" -- predug alias
FROM employees
WHERE department_id IN (10, 30, 50);

--Zadatak 7
/*
Napisati upit koji će vratiti jednu kolonu "Ime + Plata" od naziva zaposlenog i
njegove plate za sve zaposlene. Formatirati "Ime + plata" tako da je vraćena
kolona dužine 50 karaktera i s lijeve strane nadopunjena s «$» karakterom.
*/
SELECT lpad(first_name || ' + ' || salary, 50, '$') "Ime + Plata"
FROM employees;

--Zadatak 8
/*
Napisati upit koji će prikazati naziv zaposlenog i dužinu naziva zaposlenog za sve
zaposlene čija imena počinju sa slovima A, J, M i S. Naziv zaposlenog treba
prikazati tako da je prvi karakter naziva predstavljen malim slovom, a ostali
karakteri velikom slovima.
*/
SELECT lower(substr(first_name, 1, 1)) || upper(substr(first_name, 2)) naziv,
       length(first_name) as duzina_naziva
FROM employees
WHERE substr(first_name, 1, 1) IN ('A', 'J', 'M', 'S');

--Zadatak 9
/*
Napisati upit koji će prikazati naziv, datum zaposlenja i dan u sedmici kada je
zaposleni počeo da radi. Rezultati sortirati po danima u sedmici počevši od
ponedjeljka.
*/
SELECT first_name naziv,
       hire_date datum_zaposlenja,
       to_char(hire_date, 'DAY')
FROM employees
ORDER BY decode(to_char(hire_date, 'DY'),
                    'MON', 1,
                    'TUE', 2,
                    'WED', 3,
                    'THU', 4,
                    'FRI', 5,
                    'SAY', 6,
                    'SUN', 7);
                    
--Zadatak 10
/*
Napisati upit koji će prikazati naziv zaposlenog, grad u kojem zaposlenik radi, kao i
iznos dodatka na platu. Za one zaposlene koji ne dobivaju dodatak na platu ispisati
«zaposlenik ne prima dodatak na platu».
*/
SELECT e.first_name naziv,
       l.city grad,
       nvl(to_char(e.commission_pct*e.salary), 'zaposlenik ne prima dodatak na platu') dodatak_na_platu
FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id;

--Zadatak 11
/*
Napisati upit koji će prikazati naziv zaposlenog, platu i indikator plate izražene za
znakom «*». Svaka zvjezdica označava jednu hiljadu od plate. Na primjer ako
uposleni prima 2600 KM platu, tada treba za indikator plate ispisati ***, a ako
prima 2400 onda **.
*/
SELECT first_name naziv,
       salary plata,
       trim(rpad(' ', round(salary/1000)+1, '*')) indikator_plate
FROM employees;
       
-- pomoc za zad
SELECT round(salary/1000), salary
FROM employees;

--Zadatak 12
/*
Napisati upit koji će prikazati sve zaposlene s stepenom posla. Stepen posla
potrebnoa je uraditi prema sljedećoj specifikaciji:
Posao           Stepen
President       A
Manager         B
Analyst         C
Sales manager   D
Programmer      E
Ostali          X
*/
SELECT e.first_name || ' ' || e.last_name naziv,
       case
            when instr(j.job_title, 'President') > 0 then 'A'
            when instr(j.job_title, 'Manager') > 0 then 'B'
            when instr(j.job_title, 'Analyst') > 0 then 'C'
            when instr(j.job_title, 'Sales Manager') > 0 then 'D'
            when instr(j.job_title, 'Programmer') > 0 then 'E'
            else 'X'
        end stepen_posla,
        j.job_title posao
FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
ORDER BY 2;












