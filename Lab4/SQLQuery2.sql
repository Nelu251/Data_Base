

--5.Sa se afișeze lista studentilor al caror nume se termina in "u" 
SELECT Nume_Student, Prenume_Student
FROM studenti
WHERE Nume_Student like '%u'  




--18.Afitati numele si prenumele profesorilor, care au predat doar discipline cu o incarcare orara mai mica de 60 de ore. 
SELECT distinct Nume_Profesor, Prenume_Profesor
FROM studenti_reusita
INNER JOIN profesori
ON studenti_reusita.Id_Profesor=profesori.Id_Profesor
WHERE Id_Disciplina in( 
SELECT Id_Disciplina
FROM discipline
WHERE Nr_ore_plan_disciplina<60)



--23.Sa se obtina lista disciplinelor (Disciplina) sustinute de studenti cu nota medie de promovare
-- la examen mai mare de 7, in ordine descrescatoare dupa denumirea disciplinei. 


SELECT Disciplina, cast(avg(nota*1.0)as decimal(6,4)) as notaMedie
FROM studenti_reusita
INNER JOIN discipline
ON studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
Where  Tip_Evaluare='Examen'
Group by Disciplina
Having cast(avg(nota*1.0)as decimal(6,4))>7
Order by disciplina DESC 
 



--35.  Gasiti denumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii mai mari de 7.0

SELECT Disciplina, cast(avg(nota*1.0)as decimal(6,4)) as notaMedie
FROM studenti_reusita
INNER JOIN discipline
ON studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
Group by Disciplina
Having cast(avg(nota*1.0)as decimal(6,4))>7.0



--38. Furnizati denumirile disciplinelor cu o medie mai mica decat media notelor de la disciplina Baze de date. 

Select disciplina, cast(avg(nota*1.0)as decimal(6,4)) as Average
from studenti_reusita 
INNER join discipline
On studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
Group by disciplina
Having cast(avg(nota*1.0)as decimal(6,4)) < (
Select cast(avg(nota*1.0)as decimal(6,4)) Average
from studenti_reusita
INNER JOIN discipline
On studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
Where disciplina='Baze de date')

