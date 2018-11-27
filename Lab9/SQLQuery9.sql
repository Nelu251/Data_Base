--1. Sa se creeze proceduri stocate in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de
--   intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective
CREATE PROCEDURE profesori_info
				@NUMBER_OF_HOURS INT =60
AS 
 SELECT distinct cadre_didactice.profesori.Nume_Profesor, cadre_didactice.profesori.Prenume_Profesor
FROM studenti.studenti_reusita
INNER JOIN cadre_didactice.profesori
ON studenti.studenti_reusita.Id_Profesor=cadre_didactice.profesori.Id_Profesor
WHERE Id_Disciplina not in( 
SELECT discipline.Id_Disciplina
FROM plan_studii.discipline
WHERE discipline.Nr_ore_plan_disciplina>@NUMBER_OF_HOURS)
Go
EXECUTE profesori_info
GO
CREATE PROCEDURE AVERAGE_PER_DISCIPLINE
				@DISCIPLINA VARCHAR(255) = 'Baze de date'
AS
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
EXECUTE AVERAGE_PER_DISCIPLINE

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Sa se creeze o procedura stocata, care nu are niciun parametru de intrare si poseda un parametru de iesire. Parametrul de iesire 
--   trebuie sa returneze numarul de studenti, care nu au sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL). 
GO
DROP PROCEDURE IF EXISTS ST_NUMBER
GO
CREATE PROCEDURE ST_NUMBER
				@NUMBER_OF_STUDENTS INT =NULL OUTPUT
AS
SET @NUMBER_OF_STUDENTS=(
SELECT COUNT(DISTINCT ID_STUDENT) AS NUMBER_OF_ST
FROM studenti.studenti_reusita
WHERE Nota<5 OR Nota IS NULL)
GO
--EXECUTE ST_NUMBER
SET NOCOUNT ON
DECLARE @NUMBER_OF_STUDENTS INT 
EXECUTE ST_NUMBER
        @NUMBER_OF_STUDENTS OUTPUT
IF @NUMBER_OF_STUDENTS >=1 
BEGIN
PRINT 'NUMARUL DE STUDENTI CARE NU AU SUSTINUT CEL PUTIN O FORMA DE EVALUARE ESTE : ' + CAST(@NUMBER_OF_STUDENTS AS VARCHAR) +'.'
END
 GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3. Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student nou. In calitate de parametri de 
--   intrare sa serveasca datele personale ale studentului nou si Cod_ Grupa. Sa se genereze toate intrarile-cheie necesare in tabelul
--   studenti_reusita. Notele de evaluare sa fie inserate ca NULL. 
--DROP PROCEDURE NEW_STUDENT_INSERT
GO 
CREATE PROCEDURE NEW_STUDENT_INSERT
				@NUME_ST VARCHAR(20)= 'DANA',
				@PRENUME_ST VARCHAR(20)= 'SPEIANU',
				@ID_ST INT = 300, 
				@COD_GRUPA CHAR(6) ='CIB171',
				@ID_GRUPA SMALLINT = NULL OUTPUT
AS 
	INSERT INTO studenti.studenti(Id_Student, Nume_Student, Prenume_Student)
	VALUES (@ID_ST, @NUME_ST, @PRENUME_ST) 
	SET @ID_GRUPA= (SELECT ID_GRUPA FROM grupe WHERE Cod_Grupa=@COD_GRUPA)
	INSERT INTO STUDENTI.studenti_reusita
	VALUES(@ID_ST,111,104, @ID_GRUPA,'EXAMEN', NULL, NULL)
	EXEC NEW_STUDENT_INSERT
	GO
	SELECT * FROM studenti.studenti
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Fie ca un profesor se elibereaza din functie la mijlocul semestrului. Sa se creeze o procedura stocata care ar reatribui inregistrarile din tabelul 
--studenti_reusita unui alt profesor. Parametri de intrare: numele Si prenumele profesorului vechi, numele Si prenumele profesorului nou, disciplina. 
--In cazul in care datele inserate sunt incorecte sau incomplete, sa se afiseze un mesaj de avertizare. 
CREATE PROCEDURE CHANGE_PROFESOR
				 @OLD_NUME VARCHAR(10)='Munteanu',
				 @OLD_PRENUME VARCHAR(10)='Alexandru',
				 @NEW_NUME VARCHAR(10)= 'Mirela',
				 @NEW_PRENUME VARCHAR(10)= 'Verebceanu',
				 @DISCIPLINA VARCHAR(255)='Programarea declarativa',
				 @ID_PROF INT = NULL OUTPUT, 
				 @ID_DISCIPLINA VARCHAR(255)= NULL OUTPUT
AS 
IF EXISTS (
SELECT * FROM studenti.studenti_reusita 
	WHERE Id_Disciplina=   (SELECT Id_Disciplina 
							FROM plan_studii.discipline 
							WHERE Disciplina=@DISCIPLINA)
							AND
		  Id_Profesor=
						   (SELECT ID_PROFESOR 
							FROM cadre_didactice.profesori 
							WHERE Nume_Profesor=@OLD_NUME AND Prenume_Profesor=@OLD_PRENUME))
BEGIN
UPDATE cadre_didactice.profesori SET Nume_Profesor=@NEW_NUME WHERE Nume_Profesor=@OLD_NUME
UPDATE cadre_didactice.profesori SET Prenume_Profesor=@NEW_PRENUME WHERE Prenume_Profesor=@OLD_PRENUME 
END
ELSE  BEGIN PRINT 'ATENTION!!! THERE IS NO SUCH TEACHER THAT TEACHES THIS DISCIPLINE' END
EXECUTE CHANGE_PROFESOR @DISCIPLINA='Programarea declarativa'
select * from cadre_didactice.profesori

--select disciplina from PLAN_STUDII.discipline where Id_Disciplina in(
--select id_disciplina from studenti.studenti_reusita where Id_Profesor=103)

--SELECT DISTINCT DISCIPLINA, Nume_Profesor, Prenume_Profesor
--FROM PLAN_STUDII.discipline, cadre_didactice.profesori, STUDENTI.studenti_reusita
--WHERE discipline.Id_Disciplina=studenti_reusita.Id_Disciplina
--AND   profesori.Id_Profesor=studenti_reusita.Id_Profesor
--AND   studenti_reusita.Id_Profesor=103
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--6. Sa se creeze functii definite de utilizator in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de intrare 
--trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective.
GO
CREATE FUNCTION PROF_INFO_DISC(@NR_ORE_PER_DISCIPLINA INT)
RETURNS TABLE
AS
RETURN
( SELECT distinct cadre_didactice.profesori.Nume_Profesor, cadre_didactice.profesori.Prenume_Profesor
FROM studenti.studenti_reusita
INNER JOIN cadre_didactice.profesori
ON studenti.studenti_reusita.Id_Profesor=cadre_didactice.profesori.Id_Profesor
WHERE Id_Disciplina not in( 
SELECT discipline.Id_Disciplina
FROM plan_studii.discipline
WHERE discipline.Nr_ore_plan_disciplina> @NR_ORE_PER_DISCIPLINA))
SELECT * FROM DBO.PROF_INFO_DISC (60)

GO
CREATE FUNCTION DISCIPLINE_MAX_AVG (@DISCIPLINA VARCHAR(255))
RETURNS TABLE
AS
RETURN 
(Select plan_studii.discipline.disciplina, cast(avg(nota*1.0)as decimal(6,4)) as Average
from studenti.studenti_reusita 
INNER join plan_studii.discipline
On studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina
Group by  plan_studii.discipline.disciplina
Having cast(avg(nota*1.0)as decimal(6,4)) < (
Select cast(avg(nota*1.0)as decimal(6,4)) Average
from studenti.studenti_reusita
INNER JOIN plan_studii.discipline
On studenti.studenti_reusita.Id_Disciplina=plan_studii.discipline.Id_Disciplina
Where  plan_studii.discipline.disciplina=@DISCIPLINA))
GO
SELECT * FROM DBO.DISCIPLINE_MAX_AVG('Baze de date');
------------------------------------------------------------------------------------------------------------------------------------------------------------
--7.  Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al functiei: <numeJ uncfie>(<Data _ Nastere_ Student>). 
GO
--DROP FUNCTION AGE
CREATE FUNCTION AGE(@DATA_NASTERE_STUDENT DATETIME)
RETURNS INT 
BEGIN
DECLARE @Now DATETIME
DECLARE @Age INT
SET @Now=GETDate()
      SELECT @Age=(CONVERT(int,CONVERT(char(8),@Now,112))-CONVERT(char(8),@DATA_NASTERE_STUDENT,112))/10000
	  RETURN @Age
END
GO
DECLARE @DATA_NASTERE DATETIME
DECLARE @STUDENT_AGE INT
SET @DATA_NASTERE = (SELECT Data_Nastere_Student FROM STUDENTI.STUDENTI WHERE Nume_Student='Dan' and Prenume_Student='David')
PRINT 'THE AGE OF THE STUDENT IS:  ' + CAST(DBO.AGE(@DATA_NASTERE) AS VARCHAR)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--8. Sa se creeze o functie definita de utilizator, care ar returna datele referitoare la reusita unui student. Se defineste urmatorul format al functiei:
-- <nume Juncfie> (<Nume_Prenume_Student>). Sa fie afisat tabelul cu urmatoarele campuri: Nume_Prenume_Student, Disticplina, Nota, Data_Evaluare. 
GO
CREATE FUNCTION REUSITA_STUDENT(@Nume_Prenume_Student VARCHAR(255))
RETURNS TABLE
AS
RETURN
(SELECT CONCAT(Nume_Student,'   ', Prenume_Student) AS Nume_Prenume_Student ,Disciplina, Nota, Data_Evaluare
FROM studenti.studenti_reusita AS STRE
INNER JOIN studenti.studenti AS ST
ON ST.Id_Student=STRE.Id_Student
INNER JOIN PLAN_STUDII.discipline AS D
ON  D.Id_Disciplina=STRE.Id_Disciplina
WHERE STRE.Id_Student = ( SELECT Id_Student FROM studenti.studenti WHERE CONCAT(Nume_student,'   ',Prenume_student)=@Nume_Prenume_Student)
)
GO
DECLARE @NUME_PRENUME_ST VARCHAR(255)
SET @NUME_PRENUME_ST=
(SELECT CONCAT(Nume_Student,'   ',Prenume_Student)
FROM STUDENTI.STUDENTI AS ST
WHERE ST.Nume_Student='Ghimpu')
SELECT * FROM DBO.REUSITA_STUDENT(@NUME_PRENUME_ST)

-------------------------------------------------------------------------------------------------------------------------------------------------------------
--9. Se cere realizarea unei functii definite de utilizator, care ar gasi cel mai sarguincios sau cel mai slab student dintr-o grupa. Se defineste urmatorul 
--format al functiei: <numeJuncfie> (<Cod_ Grupa>, <is_good>). Parametrul <is_good> poate accepta valorile "sarguincios" sau "slab", respectiv. 
--Functia sa returneze un tabel cu urmatoarele campuri Grupa, Nume_Prenume_Student, Nota Medie , is_good. Nota Medie sa fie cu precizie de 2 zecimale
GO 
CREATE FUNCTION BEST_OR_WORST(@COD_GRUPA VARCHAR(10), @IS_GOOD VARCHAR(20))
RETURNS @TABLE TABLE
        (Nume_Prenume_Student VARCHAR(255), Cod_Grupa VARCHAR(10), Nota_Medie DECIMAL(4,2), IS_GOOD VARCHAR(20))
AS
BEGIN
IF @IS_GOOD IN ('SIRGUINCIOS')
   INSERT @TABLE
   SELECT top(1) CONCAT(NUME_STUDENT,'   ',PRENUME_STUDENT) AS Nume_Prenume_Student, Cod_Grupa AS Grupa, cast(avg(nota*1.0)as decimal(4,2)) AS Nota_Medie, @IS_GOOD AS IS_GOOD
    FROM studenti.studenti_reusita AS STRE INNER JOIN GRUPE
	ON STRE.Id_Grupa=grupe.Id_Grupa
	INNER JOIN STUDENTI.STUDENTI AS ST 
	ON ST.Id_Student=STRE.Id_Student
	WHERE Cod_grupa= @COD_GRUPA 
	AND NOTA IS NOT NULL
	GROUP BY Nume_Student, Prenume_Student,Cod_Grupa
	ORDER BY Nota_Medie DESC

   ELSE IF @IS_GOOD IN ('SLAB')
    INSERT @TABLE
	SELECT top(1) CONCAT(NUME_STUDENT,'   ',PRENUME_STUDENT) AS Nume_Prenume_Student, Cod_Grupa AS Grupa, cast(avg(nota*1.0)as decimal(4,2)) AS Nota_Medie, @IS_GOOD AS IS_GOOD
    FROM studenti.studenti_reusita AS STRE INNER JOIN GRUPE
	ON STRE.Id_Grupa=grupe.Id_Grupa
	INNER JOIN STUDENTI.STUDENTI AS ST 
	ON ST.Id_Student=STRE.Id_Student
	WHERE Cod_grupa = @COD_GRUPA 
	GROUP BY Nume_Student, Prenume_Student,Cod_Grupa
	ORDER BY Nota_Medie ASC
RETURN
END
GO
SELECT * FROM DBO.BEST_OR_WORST('TI171','SIRGUINCIOS')
SELECT * FROM DBO.BEST_OR_WORST('TI171','SLAB')
SELECT * FROM DBO.BEST_OR_WORST('CIB171','SIRGUINCIOS')
SELECT * FROM DBO.BEST_OR_WORST('CIB171','SLAB')
SELECT * FROM DBO.BEST_OR_WORST('INF171','SIRGUINCIOS')
SELECT * FROM DBO.BEST_OR_WORST('INF171','SLAB')







