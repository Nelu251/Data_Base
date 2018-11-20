


--1. Sa se creeze doua viziuni in baza interogarilor formulate in doua exercitii indicate din capitolul 4.
-- Prima viziune sa fie construita in Editorul de interogari, iar a doua, utilizand View Designer.
CREATE VIEW NUME_PRENUME_ST 
AS 
SELECT studenti.id_student, studenti.Nume_Student, studenti.Prenume_Student
FROM studenti.studenti
WHERE studenti.Nume_Student like '%u'
select * from NUME_PRENUME_ST
--drop view NUME_PRENUME_ST;
CREATE VIEW STUDENT_INFO 
AS 
SELECT studenti.studenti.Nume_Student, studenti.studenti.Prenume_Student, NOTA
FROM studenti.studenti
INNER JOIN studenti.studenti_reusita
ON STUDENTI.Id_Student= studenti_reusita.Id_Student
WHERE Nota>6


------------------------------------------------------------------------------------------------------------------------------------------------
--2. Sa se scrie cate un exemplu de instructiuni INSERT, UPDATE, DELETE asupra viziunilor create. 
--Sa se adauge comentariile respective referitoare la rezultatele executarii acestor instructiuni.
INSERT INTO NUME_PRENUME_ST (Id_Student,Nume_Student, Prenume_Student)
VALUES (332,'Mariu', 'Chetrusca')
UPDATE NUME_PRENUME_ST SET Nume_Student='Lucianuu' WHERE Nume_Student='Suciu'
DELETE FROM NUME_PRENUME_ST WHERE id_student=151 
--The delete statement doesn't word, as its not possbible, while the table has reference with 'studenti_reusita' table.

INSERT INTO profesori_new 
VALUES (222,'MIRANILON', 'BOTHER', 'MUN. UNGHENI', 'STR. NICOLAE DONICI', 12)
UPDATE profesori_new SET Id_Profesor=150 WHERE Id_Profesor=221
DELETE profesori_new WHERE Id_Profesor=150
SELECT * FROM profesori_new
SELECT * FROM NUME_PRENUME_ST

----------------------------------------------------------------------------------------------------------------------------------------------
--3. Sa se scrie instructiunile SQL care ar modifica viziunile create (in exercitiul 1) in la fel, incat sa nu fie posibila
-- modificarea sau stergerea tabelelor pe care acestea sunt definite si viziunile sa nu accepte operatiuni DML, daca conditiile
-- clauzei WHERE nu sunt satisfacute. 
ALTER VIEW NUME_PRENUME_ST
WITH SCHEMABINDING 
AS 
SELECT distinct studenti.id_student, studenti.Nume_Student, studenti.Prenume_Student
FROM studenti.studenti
WHERE studenti.Nume_Student like '%u'
WITH CHECK OPTION;
SELECT * FROM NUME_PRENUME_ST

ALTER VIEW profesori_view 
WITH SCHEMABINDING
AS
SELECT Nume_Profesor, Prenume_Profesor, Localitate
FROM  dbo.profesori_new
WHERE  (Localitate = 'mun. Chisinau') 
WITH CHECK OPTION;
SELECT * FROM profesori_view
--view based on the select that has dependencies with other tables
ALTER VIEW STUDENT_INFO 
WITH SCHEMABINDING
AS 
SELECT DISTINCT studenti.studenti.Nume_Student, studenti.studenti.Prenume_Student, NOTA
FROM studenti.studenti
INNER JOIN studenti.studenti_reusita
ON STUDENTI.Id_Student= studenti_reusita.Id_Student
WHERE Nota>8
WITH CHECK OPTION;
SELECT * FROM STUDENT_INFO

---------------------------------------------------------------------------------------------------------------------------------------------
--4. Sa se scrie instructiunile de testare a proprietatilor noi definite. 
INSERT INTO NUME_PRENUME_ST
VALUES( 22, 'Nicu','Ilianov')
INSERT INTO profesori_view
VALUES('Gheorghe', 'Leahu', 'mun. Chisinau')
INSERT INTO STUDENT_INFO
VALUES('MARIA', 'VELICOVA', 10)
UPDATE STUDENT_INFO SET NOTA=8 WHERE Nota=10

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Sa se rescrie 2 interogari formulate in exercitiile din capitolul 4, in asa fel. 
--Incat interogarile imbricate sa fie redate sub forma expresiilor CTE.
WITH DISCIPLINE_CTE(Disciplina, AVERAGE)
AS (
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
    )
SELECT Disciplina 
FROM DISCIPLINE_CTE
WHERE AVERAGE>6.7963


WITH PROFESORI_CTE(NUME, PRENUME)
AS
(
 SELECT distinct cadre_didactice.profesori.Nume_Profesor, cadre_didactice.profesori.Prenume_Profesor
FROM studenti.studenti_reusita
INNER JOIN cadre_didactice.profesori
ON studenti.studenti_reusita.Id_Profesor=cadre_didactice.profesori.Id_Profesor
WHERE Id_Disciplina not in( 
SELECT discipline.Id_Disciplina
FROM plan_studii.discipline
WHERE discipline.Nr_ore_plan_disciplina>60)
)
SELECT NUME, PRENUME
FROM PROFESORI_CTE
WHERE PRENUME LIKE '%n%'
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--6. Se considera un graf orientat, precum cel din figura de mai jos si fie se doreste parcursa calea de la nodul id = 3 la nodul unde id = 0. Sa se faca reprezentarea grafului 
--orientat in forma de expresie-tabel recursiv. Sa se observe instructiunea de dupa UNION ALL a membrului recursiv, precum si partea de pana la UNION ALL reprezentata de membrul-ancora. 
DECLARE @GRAPH TABLE  
(	ID_NODE SMALLINT,
	ID_EX_NODE SMALLINT,
	NAME_NODE VARCHAR(20)
) 
INSERT @GRAPH
VALUES 
	   (3,NULL,'LEAF_3'),
	   (2,3,'LEAF_2'),
	   (2,4,'LEAF_2'),
	   (4,NULL,'LEAF_4'),
	   (1,2,'LEAF_1'),
	   (0,1,'LEAF_0'),
	   (0,5,'LEAF_0'),
	   (5,NULL,'LEAF_5');
WITH ORIENTED_GRAPH
AS
(
	SELECT *,3 AS INIT_NODE
	FROM @GRAPH
	WHERE ID_NODE=3
	  AND ID_EX_NODE IS NULL
 UNION ALL 
	SELECT GRAPH.*, INIT_NODE - 1
	FROM @GRAPH AS GRAPH
	INNER JOIN ORIENTED_GRAPH
	ON GRAPH.ID_EX_NODE=ORIENTED_GRAPH.ID_NODE
	WHERE INIT_NODE>=0
)
SELECT * FROM ORIENTED_GRAPH


 





