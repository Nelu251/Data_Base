--1.Sa se modifice declansatorul inregistrare_noua, in asa fel, incat in cazul actualizarii auditoriului sa apara mesajul de informare, care, in afara 
--  de disciplina si ora, va afisa codul grupei afectate, ziua, blocul, auditoriul vechi si auditoriul nou. 
USE universitatea 
GO 
DROP TRIGGER IF EXISTS dbo.inregistrare_noua 
GO 
CREATE TRIGGER inregistrare_noua ON orarul 
AFTER INSERT 
AS 
PRINT 'O noua inregistrare a fost inclusa cu succes' 
GO
INSERT orarul VALUES (111 ,115, 3, 'Lu', '08:00',502,'B')
GO 
SELECT * FROM orarul
GO  
ALTER TRIGGER inregistrare_noua 
ON orarul 
AFTER UPDATE 
AS SET NOCOUNT ON 
IF UPDATE (Auditoriu)  
SELECT 'Lectia la disciplina   '+ UPPER(d.Disciplina)+
	   '  de la ora  ' + CAST(inserted.Ora AS VARCHAR (5))+ '  a grupei codul careia este  ' + 
	    CAST(inserted.Id_Grupa AS CHAR(3))+ 'in ziua ' + CAST(inserted.Zi as VarChar(2)) + ' din Blocul '+ CAST(inserted.Bloc as VarChar(1)) +'   a fost tranferata din Auditoriul ' + CAST(deleted.Auditoriu AS CHAR(3)) + '   in Auditoriul ' + CAST(inserted.Auditoriu AS CHAR(3))
FROM inserted JOIN plan_studii.discipline d ON inserted.Id_Disciplina = d.Id_Disciplina
JOIN deleted ON deleted.Id_Disciplina = d.Id_Disciplina
GO 
UPDATE orarul SET Auditoriu=121 WHERE Zi='Lu'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Sa se creeze declansatorul, care ar asigura popularea corecta (consecutiva) a tabelelor studenti 
--si studenti_reusita, si ar permite evitarea erorilor la nivelul cheilor extene. 
GO
CREATE TRIGGER POPULAREA_CORECTA on studenti.studenti_reusita
	INSTEAD OF INSERT
	AS SET NOCOUNT ON
		DECLARE @Id_Student INT 
		,@Nume_Student VARCHAR(50) ='Verebceanu'
		,@Prenume_Student VARCHAR(50) ='Alexandru'
		SELECT @Id_Student = Id_Student FROM inserted
		INSERT INTO studenti.studenti VALUES(@Id_Student, @Nume_Student, @Prenume_Student, null, null)
		INSERT INTO studenti.studenti_reusita 
		SELECT * FROM inserted

		INSERT INTO studenti.studenti_reusita VALUES(200,108,101,3,'Testul 2', null, null)
		SELECT * FROM studenti.studenti
		SELECT DISTINCT * FROM studenti.studenti_reusita
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 3. Sa se creeze un declansator, care ar interzice micsorarea notelor in tabelul studenti_reusita si modificarea valorilor campului Data_Evaluare, 
--unde valorile acestui camp sunt nenule. Declansatorul trebuie sa se lanseze, numai daca sunt afectate datele studentilor din grupa "CIB171 ". 
--Se va afisa un mesaj de avertizare in cazul tentativei de a incalca constrangerea.  
CREATE TRIGGER change_Column ON studenti.studenti_reusita
AFTER UPDATE
AS
SET NOCOUNT ON
 IF UPDATE(NOTA)
DECLARE @ID_GRUPA INT = (select Id_Grupa from grupe where Cod_Grupa='CIB171')
IF (SELECT AVG(NOTA) FROM deleted WHERE Id_Grupa=@ID_GRUPA AND NOTA IS NOT NULL)>(SELECT AVG(NOTA) FROM inserted WHERE Id_Grupa=@ID_GRUPA AND NOTA IS NOT NULL)
BEGIN
PRINT('Nu se permite miscrorarea notelor pentru grupa CIB171')
ROLLBACK TRANSACTION
END
IF UPDATE(DATA_EVALUARE)
BEGIN 
PRINT 'Nu poti modifica campul Data_Evaluare'
ROLLBACK TRANSACTION
end
UPDATE studenti.studenti_reusita SET Nota=nota-1 WHERE Id_Grupa= (select Id_Grupa from grupe where Cod_Grupa='CIB171')
UPDATE studenti.studenti_reusita SET Data_Evaluare='2018-01-25' WHERE Id_Grupa= (select Id_Grupa from grupe where Cod_Grupa='CIB171'
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Sa se creeze un declanSator DDL care ar interzice modificarea coloanei ld_Disciplina in tabelele bazei de date universitatea cu afiSarea mesajului respectiv. 
DROP TRIGGER ID_DISC_MODIFIER ON DATABASE
CREATE TRIGGER ID_DISC_MODIFIER
ON DATABASE 
FOR ALTER_TABLE
AS 
SET NOCOUNT ON
DECLARE @DISCIPLINA VARCHAR(100)
SET @DISCIPLINA= EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]','nvarchar(max)') 

IF @DISCIPLINA ='Disciplina'
BEGIN
PRINT('Nu poate fi modificata coloana Disciplina');
ROLLBACK;
END 
go

	ALTER TABLE discipline 
	ALTER COLUMN Disciplina varchar(200)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Sa se creeze un declanSator DDL care ar interzice modificarea schemei bazei de date in afara orelor de lucru. 
CREATE TRIGGER out_of_time ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @TimpulCurent DATETIME
DECLARE @LucruStart DATETIME
DECLARE @LucruEnd DATETIME
DECLARE @BEFORE_START FLOAT
DECLARE @AFTER_START FLOAT
SELECT @TimpulCurent = GETDATE()
SELECT @LucruStart = '2011-12-22 9:00:00.000'
SELECT @LucruEnd = '2011-12-22 18:00:00.000'
SELECT @BEFORE_START =(cast(@TimpulCurent as float) - floor(cast(@TimpulCurent as float)))-
 (cast(@LucruStart as float) - floor(cast(@LucruStart as FLOAT))),
       @AFTER_START = (cast(@TimpulCurent as float) - floor(cast(@TimpulCurent as float))) -
 (cast(@LucruEnd as float) - floor(cast(@LucruEnd as FLOAT)))
IF @BEFORE_START<0 OR @AFTER_START>0
BEGIN
PRINT ('SE INTERZICE MODIFCAREA SCHEMEI BAZEI DE DATE INAFARA ORELOR DE LUCRU')
ROLLBACK
END

ALTER TABLE STUDENTI.STUDENTI 
ADD tEST INT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--6.  Sa se creeze un declansator DDL care, la modificarea proprietatilor coloanei ld_Profesor dintr-un tabel, 
--ar face schimbari asemanatoare in mod automat in restul tabelelor. 
 go
 drop trigger change_all on database
 go
 CREATE TRIGGER change_all ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @Prenume_profesor varchar(30)
DECLARE @int_I varchar(500)
DECLARE @int_M varchar(500)
DECLARE @den_T varchar(50)
SELECT @Prenume_profesor=EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]','nvarchar(max)')
IF @Prenume_profesor= 'Prenume_Profesor'
BEGIN 
SELECT @int_I = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
SELECT @den_T = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)')
SELECT @int_M = REPLACE(@int_I, @den_T, 'profesori'); EXECUTE (@int_M)
SELECT @int_M = REPLACE(@int_I, @den_T, 'profesori_new'); EXECUTE (@int_M)
PRINT 'Datele au fost modificate in toate tabelele'
END
go	
alter table profesori alter column Prenume_profesor varchar(80)