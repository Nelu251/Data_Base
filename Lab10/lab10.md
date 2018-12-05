
## Laboratory 10

*Sarcini Practice*

**1. Sa se modifice declansatorul inregistrare_noua, in asa fel, incat in cazul actualizarii auditoriului sa apara mesajul de informare, care, in afara de disciplina si ora, va afisa codul grupei afectate, ziua, blocul, auditoriul vechi si auditoriul nou.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger1.PNG)

**2. Sa se creeze declansatorul, care ar asigura popularea corecta (consecutiva) a tabelelor studenti si studenti_reusita, si ar permite evitarea erorilor la nivelul cheilor extene.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger2.PNG)

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger22.PNG)

**3. Sa se creeze un declansator, care ar interzice micsorarea notelor in tabelul studenti_reusita si modificarea valorilor campului Data_Evaluare, unde valorile acestui camp sunt nenule. Declansatorul trebuie sa se lanseze, numai daca sunt afectate datele studentilor din grupa "CIB171 ". Se va afisa un mesaj de avertizare in cazul tentativei de a incalca constrangerea.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger3.PNG)

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger33.PNG)

**4. Sa se creeze un declanSator DDL care ar interzice modificarea coloanei ld_Disciplina in tabelele bazei de date universitatea cu afiSarea mesajului respectiv.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger4.PNG)

**5. Sa se creeze un declanSator DDL care ar interzice modificarea schemei bazei de date in afara orelor de lucru.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger5.PNG)

**6. Sa se creeze un declansator DDL care, la modificarea proprietatilor coloanei ld_Profesor dintr-un tabel, ar face schimbari asemanatoare in mod automat in restul tabelelor.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab10/Lam10images/trigger6.PNG)

``SQL 
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
``

