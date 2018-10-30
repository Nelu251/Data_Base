

--1. Completati urmatorul cod pentru a afisa eel mai mare numar dintre cele trei numere prezentate:
DECLARE @Nl INT, @N2 INT, @N3 INT; 
DECLARE @MAI_MARE INT; 
SET @Nl = 60 * RAND(); 
SET @N2 = 60 * RAND(); 
SET @N3 = 60 * RAND(); 
-- Aici ar trebui plasate IF-urile 
SET @MAI_MARE = @Nl;
IF @MAI_MARE < @N2 
   SET @MAI_MARE = @N2
   ELSE if @MAI_MARE < @N3
   SET  @MAI_MARE = @N3
   ELSE  SET @MAI_MARE = @Nl;

PRINT @Nl; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 


-- 2.Afisati primele zece date(numele, prenumele studentului) in functie de valoarea notei (cu exceptia notelor 6 si 8)
--a studentului la primul test al disciplinei Baze de date, folosind structura de altemativa IF. .. ELSE. 
--Sa se foloseasca variabilele.
DECLARE @notNR1 int=6;
DECLARE @notNR2 int=8;
DECLARE @disciplina varchar(255) ='Baze de date';
DECLARE @tipevaluare varchar(90) ='Testul 1';

 IF @notNR1 != any
  (SELECT nota from studenti_reusita
  INNER JOIN discipline
  ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
  Where Disciplina=@disciplina and Tip_Evaluare=@tipevaluare)
   OR @notNR2 != ANY 
  (SELECT nota from studenti_reusita
  INNER JOIN discipline
  ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
  Where Disciplina=@disciplina and Tip_Evaluare=@tipevaluare) 
  begin 
Select  distinct top (10) Nume_Student, Prenume_Student, Nota, Tip_Evaluare, Disciplina
from studenti
INNER JOIN studenti_reusita
ON studenti.Id_Student=studenti_reusita.Id_Student
INNER JOIN discipline
 ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
Where Disciplina=@disciplina and Tip_Evaluare=@tipevaluare and nota not in (@notNR1, @notNR2) 
end
 else print 'Nu sunt alte note decat 6 si 8';
 go
  
 --3.Rezolvati aceesi sarcina, 1, apeland la structura selectiva CASE. 
 DECLARE @Nl INT, @N2 INT, @N3 INT; 
 DECLARE @MAI_MARE INT; 
SET @Nl = 60 * RAND(); 
SET @N2 = 60 * RAND(); 
SET @N3 = 60 * RAND(); 
-- Aici ar trebui plasate IF-urile 
SET @MAI_MARE= @Nl;
 SET @MAI_MARE =
CASE
WHEN @MAI_MARE < @N2 and @N2 > @N3 THEN  @N2
WHEN @MAI_MARE < @N3 and @N2 < @N3 THEN  @N3  ELSE @Nl

  END
PRINT @Nl; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 


--4. Modificati exercitiile din sarcinile 1 si 2 pentru a include procesarea erorilor cu TRY, CATCH, si RAISERRROR. \
--4.1 USING TRY AND CATCH
BEGIN TRY
DECLARE @Nl INT, @N2 INT, @N3 INT; 
DECLARE @MAI_MARE INT; 
SET @Nl = sqrt(-4); 
SET @N2 = 60 * RAND(); 
SET @N3 = 60 * RAND(); 
SET @MAI_MARE = @Nl;
 IF @MAI_MARE < @N2  SET @MAI_MARE = @N2
 ELSE if @MAI_MARE < @N3 SET @MAI_MARE = @N3
 ELSE  SET @MAI_MARE = @Nl;

PRINT @Nl; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 
END TRY
BEGIN CATCH 
PRINT ERROR_NUMBER()
PRINT ERROR_SEVERITY()
PRINT ERROR_STATE()
PRINT ERROR_LINE() 
PRINT ERROR_MESSAGE() 
END CATCH 
--4.2 USSING RAISERROR
DECLARE @notNR1 int=0;
DECLARE @notNR2 int=8;
DECLARE @disciplina varchar(255) ='Baze de date';
DECLARE @tipevaluare varchar(90) ='Testul 1';
  
 IF @notNR1 != any
  (SELECT nota from studenti_reusita
  INNER JOIN discipline
  ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
  Where Disciplina=@disciplina and Tip_Evaluare=@tipevaluare)
   OR @notNR2 != ANY 
  (SELECT nota from studenti_reusita
  INNER JOIN discipline
  ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
  Where Disciplina=@disciplina and Tip_Evaluare=@tipevaluare) 
  begin 
Select  distinct top (10) Nume_Student, Prenume_Student, Nota, Tip_Evaluare, Disciplina
from studenti
INNER JOIN studenti_reusita
ON studenti.Id_Student=studenti_reusita.Id_Student
INNER JOIN discipline
 ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
Where Disciplina=@disciplina and Tip_Evaluare=@tipevaluare and nota not in (@notNR1, @notNR2) 
end
 else print 'Nu sunt alte note decat 6 si 8';
 IF (@notNR1=0)
BEGIN
 RAISERROR ('SUCH MARK DOESNT EXIST',16, 1)
END



