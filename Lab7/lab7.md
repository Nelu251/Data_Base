## Laboratory 7

*Sarcini Practice*

**1. Creati o diagrama a bazei de date, folosind forma de vizualizare standard, structura careia este descrisa la inceputul sarcinilor practice din capitolul 4.**

![img1](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/lab7.PNG)

**2. Sa se adauge constrangeri referentiale (legate cu tabelele studenti si profesori) necesare coloanelor Sef_grupa si Prof_Indrumator (sarcina3, capitolul 6) din tabelul grupe.**

![img](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.2.PNG)

![img2](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.2.1.PNG)

![img3](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.2.2.PNG)

**3.La diagrama construitii, sa se adauge si tabelul orarul definit in capitolul 6 al acestei lucrari: tabelul orarul contine identificatorul disciplinei (ld_Disciplina), identificatorul profesorului (Id_Profesor) si blocul de studii (Bloc). Cheia tabelului este constituita din trei cfunpuri: identificatorul grupei (Id_ Grupa), ziua lectiei (Z1), ora de inceput a lectiei (Ora), sala unde are loc lectia (Auditoriu).**

![img4](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.3.PNG)

**4.Tabelul orarul trebuie sa contina si 2 chei secundare: (Zi, Ora, Id_ Grupa, Id_ Profesor) si (Zi, Ora, ld_Grupa, ld_Disciplina).**

![img5](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.4.PNG)

**5.in diagrama, de asemenea, trebuie sa se defineasca constrangerile referentiale (FK-PK) ale atributelor ld_Disciplina, ld_Profesor, Id_ Grupa din tabelului orarul cu atributele tabelelor respective.**

![img5](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.5.1.PNG)

![img5.2](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.5.2.PNG)

![img5.3](https://github.com/nadiusa/Data_Base/blob/master/Lab7/Lab7/img7.5.3.PNG)

**6.Creati, in baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii si studenti. Transferati tabelul profesori din schema dbo in schema cadre didactice, tinand cont de dependentelor definite asupra tabelului mentionat. in acelasi mod sa se trateze tabelele orarul, discipline care apartin schemei plan_studii si tabelele studenti, studenti_reusita, care apartin schemei studenti. Se scrie instructiunile SQL respective.**
CREATE SCHEMA cadre_didactice;

 go
 
 CREATE SCHEMA plan_studii;
 
 go
 
 CREATE SCHEMA studenti; 
 
 go
 
 ALTER SCHEMA cadre_didactice TRANSFER dbo.profesori 
 
 ALTER SCHEMA plan_studii TRANSFER dbo.orarul
 
 ALTER SCHEMA plan_studii TRANSFER dbo.discipline
 
 ALTER SCHEMA studenti TRANSFER dbo.studenti_reusita 
 
 
 **7. Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele tabelelor accesate sa fie descrise in mod explicit, tinand cont de faptul ca tabelele au fost mutate in scheme noi.**
 
 --Quiery5.Sa se afișeze lista studentilor al caror nume se termina in "u" 
 
SELECT studenti.studenti.Nume_Student, studenti.studenti.Prenume_Student

FROM studenti.studenti

WHERE studenti.studenti.Nume_Student like '%u'

 --Quiery 18.
 ```sql
 SELECT distinct cadre_didactice.profesori.Nume_Profesor, cadre_didactice.profesori.Prenume_Profesor
 
FROM studenti.studenti_reusita

INNER JOIN cadre_didactice.profesori

ON studenti.studenti_reusita.Id_Profesor=cadre_didactice.profesori.Id_Profesor

WHERE Id_Disciplina not in( 

SELECT discipline.Id_Disciplina

FROM plan_studii.discipline

WHERE discipline.Nr_ore_plan_disciplina>60)
```

--Quiery38.

Select plan_studii.discipline.disciplina, cast(avg(nota*1.0)as decimal(6,4)) as Average

from studenti.studenti_reusita 

INNER join plan_studii.discipline

On studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina

Group by  plan_studii.discipline.disciplina

Having cast(avg(nota*1.0)as decimal(6,4)) < (

Select cast(avg(nota*1.0)as decimal(6,4)) Average

from studenti.studenti_reusita

INNER JOIN plan_studii.discipline

On studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina

Where  plan_studii.discipline.disciplina='Baze de date')


**8. Creati sinonimele respective pentru a simplifica interogarile construite in exercitiul  precedent si reformulati interogarile, folosind sinonimele create.**

CREATE SYNONYM studenti_1 FOR  studenti.studenti;

CREATE SYNONYM studenti_reu FOR  studenti.studenti_reusita;

CREATE SYNONYM discipline_1 FOR plan_studii.discipline

CREATE SYNONYM profesori_1 FOR cadre_didactice.profesori

--quiery5:

SELECT Nume_student,Prenume_student

FROM studenti_1

WHERE Nume_student like '%u'

--quiery18

SELECT distinct Nume_profesor, Prenume_profesor

FROM studenti_reu

INNER JOIN profesori_1

ON studenti_reu.Id_Profesor=profesori_1.Id_Profesor

WHERE Id_Disciplina not in( 

SELECT Id_Disciplina

FROM discipline_1

WHERE Nr_ore_plan_disciplina>60)

--quiery38

Select disciplina, cast(avg(nota*1.0)as decimal(6,4)) as Average

from studenti_reu 

INNER join discipline_1

On studenti_reu.Id_Disciplina=discipline_1.Id_Disciplina

Group by disciplina

Having cast(avg(nota*1.0)as decimal(6,4)) < (

Select cast(avg(nota*1.0)as decimal(6,4)) Average

from studenti_reu

INNER JOIN discipline_1

On studenti_reu.Id_Disciplina=discipline_1.Id_Disciplina

Where disciplina='Baze de date')



