--6.Creati, in baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii si studenti. Transferati tabelul profesori din 
--schema dbo in schema cadre didactice, tinand cont de dependentelor definite asupra tabelului mentionat. in acelasi mod sa se trateze 
--tabelele orarul, discipline care apartin schemei plan_studii si tabelele studenti, studenti_reusita, care apartin schemei studenti. 
--Se scrie instructiunile SQL respective. 
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
 --7. Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele
 -- tabelelor accesate sa fie descrise in mod explicit, tinand cont de faptul ca tabelele au fost mutate in scheme noi.
 
 --Quiery5.Sa se afișeze lista studentilor al caror nume se termina in "u" 
SELECT studenti.studenti.Nume_Student, studenti.studenti.Prenume_Student
FROM studenti.studenti
WHERE studenti.studenti.Nume_Student like '%u'
 --Quiery 18.
 SELECT distinct cadre_didactice.profesori.Nume_Profesor, cadre_didactice.profesori.Prenume_Profesor
FROM studenti.studenti_reusita
INNER JOIN cadre_didactice.profesori
ON studenti.studenti_reusita.Id_Profesor=cadre_didactice.profesori.Id_Profesor
WHERE Id_Disciplina not in( 
SELECT discipline.Id_Disciplina
FROM plan_studii.discipline
WHERE discipline.Nr_ore_plan_disciplina>60)
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

--8. Creati sinonimele respective pentru a simplifica interogarile construite in exercitiul 
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

