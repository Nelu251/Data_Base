
 --1.Sa se scrie o instructiune T-SQL, care ar popula coloana Adresa _ Postala _ Profesor 
 --din tabelul profesori cu valoarea 'mun. Chisinau', unde adresa este necunoscuta
 UPDATE profesori SET Adresa_Postala_Profesor = 'mun. Chisinau' WHERE Adresa_Postala_Profesor is null; 
 select * from profesori
 -------------------------------------------------------------------------------------------------------------------------------------------

 --2.Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte:
 -- a) Campul Cod_ Grupa sa accepte numai valorile unice si sa nu accepte valori necunoscute.
 -- b) Sa se tina cont ca cheie primara, deja, este definita asupra coloanei Id_ Grupa.  
 ALTER TABLE grupe 
ADD UNIQUE (Cod_Grupa);

ALTER TABLE grupe
ALTER COLUMN Cod_Grupa char(6) NOT NULL
select * from grupe

 --------------------------------------------------------------------------------------------------------------------------------------------

 --3. La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa si Prof_Indrumator, ambele de tip INT. Sa se populeze campurile nou-create
 -- cu cele mai potrivite candidaturi in baza criteriilor de mai jos: 
 --a) Seful grupei trebuie sa aiba cea mai buna reusita (medie) din grupa la toate formele de evaluare si la toate disciplinele. 
 --Un student nu poate fi sef de grupa la mai multe grupe.
 --b) Profesorul fndrumator trebuie sa predea un numar maximal posibil de discipline la grupa data. Daca nu exista o singura candidatur, 
 --care corespunde primei cerinte, atunci este ales din grupul de candidati acel cu identificatorul (Id_Profesor) minimal.
 -- Un profesor nu poate fi indrumator la mai multe grupe.
 --c) Sa se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor in tabelul grupe, pentru 
 -- selectarea candidatilor si inserarea datelor. 
--ALTER TABLE GRUPE DROP COLUMN sef_grupa, prof_indrumator

Alter table grupe add sef_grupa int 
Alter table grupe add prof_indrumator int 
DECLARE c1 CURSOR FOR 
SELECT id_grupa FROM grupe 

DECLARE @gid int
    ,@sid int
    ,@pid int

OPEN c1
FETCH NEXT FROM c1 into @gid 
WHILE @@FETCH_STATUS = 0
BEGIN
 SELECT TOP 1 @sid=id_student
   FROM studenti_reusita
   WHERE id_grupa = @gid and Id_Student NOT IN (SELECT isnull(sef_grupa,'') FROM grupe)
   GROUP BY id_student
   ORDER BY cast(AVG(Nota*1.0) as decimal(6,4)) DESC

 SELECT TOP 1 @pid=id_profesor
      FROM studenti_reusita
      WHERE id_grupa = @gid AND Id_profesor NOT IN (SELECT isnull (prof_indrumator, '') FROM grupe)
      GROUP BY id_profesor
      ORDER BY count (DISTINCT id_disciplina) DESC, id_profesor
 
 UPDATE grupe
    SET   sef_grupa = @sid
      ,prof_indrumator = @pid
  WHERE Id_Grupa=@gid
 FETCH NEXT FROM c1 into @gid 
END

CLOSE c1
DEALLOCATE c1
select * from grupe

--------------------------------------------------------------------------------------------------------------------------------------------
--4. Sa se scrie o instructiune T-SQL, 
--care ar mari toate notele de evaluare sefilor de grupe cu un punct.
-- Nota maximala (10) nu poate fi marita. 
DECLARE @ID_SEF_1 FLOAT;
DECLARE @ID_SEF_2 FLOAT;
DECLARE @ID_SEF_3 FLOAT;
DECLARE @NOTA_MAX INT =10;
SET @ID_SEF_1=(SELECT TOP 1 sef_grupa from grupe)
SET @ID_SEF_2=(SELECT TOP 1 sef_grupa from grupe 
               WHERE sef_grupa IN 
			                   (select top 2 sef_grupa from grupe
							    order by sef_grupa asc)
			  ORDER BY sef_grupa DESC
                   )
SET @ID_SEF_3=(SELECT TOP 1 sef_grupa from grupe 
               WHERE sef_grupa IN 
			                   (select top 3 sef_grupa from grupe
							    order by sef_grupa asc)
			   ORDER BY sef_grupa DESC
                   )

UPDATE studenti_reusita SET Nota=Nota+1 WHERE Id_Student IN(@ID_SEF_1, @ID_SEF_2, @ID_SEF_3) AND Nota!=10
select nota from studenti_reusita
--------------------------------------------------------------------------------------------------------------------------------------------
--5. Sa se creeze un tabel profesori_new, care include urmatoarele coloane:
-- Id_Profesor, Nume _ Profesor, Prenume _ Profesor, Localitate, Adresa _ 1, Adresa _ 2. 
--a) Coloana Id_Profesor trebuie sa fie definita drept cheie primara si, in baza ei, sa fie construit un index CLUSTERED.
--b) Campul Localitate trebuie sa posede proprietatea DEFAULT= 'mun. Chisinau'. 
--c) Sa se insereze toate datele din tabelul profesori si tabelul profesori_new. 
--Sa se scrie, cu acest scop, un numar potrivit de instructiuni T-SQL. Datele trebuie sa fie transferate in felul urmator: 
--Coloana-sursa     Coloana-destinatie 
--Id Profesor       Id Profesor 
--Nume Profesor     Nume Profesor 
--Prenume Profesor  Prenume Profesor 
--Adresa Postala Profesor  Localitate 
--Adresa Postala Profesor Adresa 1
-- Adresa Pastala Profesor Adresa 2
 --In coloana Localitate sa fie inserata doar informatia despre denumirea localitatii din coloana-sursa Adresa_Postala_Profesor. 
 --In coloana Adresa_l, doar denumirea strazii. in coloana Adresa_2, sa se pastreze numarul casei si (posibil) a apartamentului.
CREATE TABLE profesori_new(  Id_Profesor INT NOT NULL,
                             Nume_Profesor varchar(60),
							 Prenume_Profesor varchar(60),
							 Localitate varchar(255) DEFAULT ('mun. Chisinau'), 
							 Adresa_1 varchar(255), 
							 Adresa_2 varchar(255),
			   			   CONSTRAINT [PK_profesori_new] PRIMARY KEY CLUSTERED 
                           (Id_Profesor )) ON [PRIMARY];

INSERT INTO profesori_new(Id_Profesor, Nume_Profesor, Prenume_Profesor, Localitate, Adresa_1, Adresa_2)
 SELECT Id_Profesor
        , Nume_Profesor
		, Prenume_Profesor
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 then  Substring(Adresa_Postala_Profesor,1, dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 THEN Substring(Adresa_Postala_Profesor,1, charindex(',',Adresa_Postala_Profesor)-1)
		ELSE Adresa_Postala_Profesor
		END as  localitate
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 then  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1, (dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1)+1,(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1))-1)
		ELSE NULL
		END as  Adresa_1
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 then  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3)+1, 5)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1, 5)
		ELSE NULL
		END as  Adresa_2
		 FROM profesori
		 select * from profesori_new
-------------------------------------------------------------------------------------------------------------------------------------------------

 --6. Sa se insereze datele in tabelul orarul pentru Grupa= 'CIB171' (Id_ Grupa= 1) pentru ziua de luni.
 --Toate lectiile vor avea loc iN blocul de studii 'B'. Mai jos, sunt prezentate detaliile de inserare:
  --(ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202); 
  --(Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501);
  --(ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501);
   
  select * from orarul
   --ALTER TABLE orarul ADD Bloc CHAR(1) NOT NULL; 
   --IF OBJECT_ID('orarul', 'U') is not null DROP TABLE orarul
  CREATE TABLE orarul( Id_Disciplina int,
                       Id_Profesor int, 
					   Id_Grupa smallint,
					   Zi       char(2),
					   Ora       Time,
					   Auditoriu  int,
					   Bloc       char(1) NOT NULL DEFAULT ('B'))

INSERT orarul (Id_Disciplina, Id_Profesor,Id_Grupa,Zi, Ora, Auditoriu)
                VALUES(107, 101, 1, 'Lu', '08:00', 202)
INSERT orarul(Id_Disciplina, Id_Profesor,Id_Grupa,Zi, Ora, Auditoriu)
               VALUES(108, 101, 1, 'Lu', '11:30', 501)
INSERT orarul (Id_Disciplina, Id_Profesor,Id_Grupa,Zi, Ora, Auditoriu)
               VALUES(119, 117, 1, 'Lu', '13:00', 501)

------------------------------------------------------------------------------------------------------------------------------
--7. Sa se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INF171 , ziua de luni.  
--Datele necesare pentru inserare trebuie sa fie colectate cu ajutorul instructiunii/instructiunilor SELECT si 
--introduse in tabelul-destinatie, stiind ca: 
--lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Profesor ='Bivol Ion') 
--lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin') 
--lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena') 
DECLARE @ID_DISCIPLINA_1 INT;
DECLARE @ID_DISCIPLINA_2 INT;
DECLARE @ID_DISCIPLINA_3 INT;
DECLARE @ID_PROFESOR_1 INT;
DECLARE @ID_PROFESOR_2 INT;
DECLARE @ID_PROFESOR_3 INT;
DECLARE @ID_GRUPA SMALLINT;
SET @ID_DISCIPLINA_1=( SELECT Id_Disciplina
					   FROM discipline
					   WHERE Disciplina = 'Structuri de date si algoritmi')
SET @ID_DISCIPLINA_2=( SELECT Id_Disciplina
                       FROM discipline
					   WHERE Disciplina = 'Programe aplicative')
SET @ID_DISCIPLINA_3=( SELECT Id_Disciplina
                       FROM discipline
					   WHERE Disciplina = 'Baze de date')
SET @ID_PROFESOR_1= ( SELECT Id_Profesor
                      FROM profesori
					  WHERE Nume_Profesor='Bivol' and Prenume_Profesor='Ion' )
SET @ID_PROFESOR_2= ( SELECT Id_Profesor
                      FROM profesori
					  WHERE Nume_Profesor='Mircea' and Prenume_Profesor='Sorin')
SET @ID_PROFESOR_3= ( SELECT Id_Profesor
                      FROM profesori
					  WHERE Nume_Profesor='Micu' and Prenume_Profesor='Elena')
SET @ID_GRUPA= (SELECT Id_Grupa
                FROM grupe
				WHERE Cod_Grupa='INF171')						
INSERT orarul (Id_Disciplina, Id_Profesor, Id_Grupa, Zi,Ora) 
VALUES (@ID_DISCIPLINA_1, @ID_PROFESOR_1, @ID_GRUPA, 'Lu', '08:00'),
       (@ID_DISCIPLINA_2, @ID_PROFESOR_2, @ID_GRUPA, 'Lu', '11:30'),
	   (@ID_DISCIPLINA_3, @ID_PROFESOR_3, @ID_GRUPA, 'Lu', '13:00');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--8. Sa se scrie interogarile de creare a indecsilor asupra tabelelor din baza de date universitatea pentru a asigura o performanta sporita la executarea
-- interogarilor SELECT din Lucrarea practica 4. Rezultatele optimizarii sa fie analizate in baza planurilor de executie, pana la si dupa crearea indecsilor.
-- Indecsii nou-creati sa fie plasati fizic in grupul de fisiere userdatafgroupl (Crearea si intrefinerea bazei de date - sectiunea 2.2.2)
ALTER DATABASE universitatea
ADD FILEGROUP userdatafgroupl
GO

ALTER DATABASE universitatea
ADD FILE
( NAME = Indexes,
FILENAME = 'd:\db.ndf',
SIZE = 1MB
)
TO FILEGROUP userdatafgroupl
GO

CREATE NONCLUSTERED INDEX pk_id_disciplina ON
discipline (id_disciplina)
ON [userdatafgroupl]
										
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;
DBCC FREESYSTEMCACHE('ALL');
GO
SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT distinct Nume_Student, Prenume_Student, avg(nota) Average
FROM studenti.studenti
INNER JOIN studenti.studenti_reusita ON studenti.Id_Student=studenti_reusita.Id_Student
where Id_Disciplina Not IN (
SELECT  distinct ID_disciplina
FROM studenti.studenti_reusita
WHERE Id_Profesor IN
(SELECT Id_Profesor
FROM cadre_didactice.profesori
where Adresa_Postala_Profesor  like '%31 August%')
and Nota<5)
group by Nume_Student, Prenume_Student;
SET STATISTICS TIME OFF

CREATE NONCLUSTERED INDEX ix_disciplina ON
plan_studii.discipline (id_disciplina, disciplina)
ON [userdatafgroupl]

CREATE COLUMNSTORE INDEX ix_profesor ON
cadre_didactice.profesori (id_profesor, Adresa_Postala_Profesor)
ON [userdatafgroupl]


--------------------------------------------------------------------------------------------------------------------------------


