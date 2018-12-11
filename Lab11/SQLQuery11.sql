--1. Sa se creeze un dosar Backup_lab11. Sa se execute un backup complet al bazei de date universitatea in acest dosar. 
--   Fisierul copiei de rezerva sa se numeasca exercitiul1.bak. Sa se scrie instructiunea SQL respectiva.

IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device4')
EXEC sp_dropdevice 'device04' , 'delfile';
EXEC sp_addumpdevice 'DISK', 'device04','D:\University_Maps\Anul2\DB\Backup_lab11\device04_exercitiul1.bak'
GO 
BACKUP DATABASE universitatea
TO device04 WITH FORMAT,
NAME = N'universitatea-Full Database Backup'
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Sa se scrie instructiunea unui backup diferentiat al bazei de date universitatea. Fisierul copiei de rezerva sa se numeasca exercitiul2.bak. 
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device01')
EXEC sp_dropdevice 'device01' , 'delfile';

EXEC sp_addumpdevice 'DISK', 'device01','D:\University_Maps\Anul2\DB\Backup_lab11\device01_exercitiul2.bak'
GO 
BACKUP DATABASE universitatea
TO device01 WITH FORMAT,
NAME = N'universitatea-Differential Database Backup'
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3. Sa se scrie instructiunea unui backup al jurnalului de tranzactii al bazei de date universitatea. Fisierul copiei de rezerva sa se numeasca exercitiul3.bak

IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup_Log')
EXEC sp_dropdevice 'backup_Log' , 'delfile';
GO
EXEC sp_addumpdevice 'DISK', 'backup_Log', 'D:\University_Maps\Anul2\DB\Backup_lab11\exercitiul3.bak'
GO
BACKUP LOG universitatea TO backup_Log
GO 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Sa se execute restaurarea consecutiva a tuturor copiilor de rezerva create. Recuperarea trebuie sa fie realizata intr-o baza de date noua universitatea_lab11. 
--Fisierele bazei de date noi se afla in dosarul BD_lab11. Sa se scrie instructiunile SQL respective.
IF EXISTS (SELECT * FROM master.sys.databases WHERE name='universitatea_lab11')
DROP DATABASE universitatea_lab11;
GO
RESTORE DATABASE universitatea_lab11
FROM DISK ='D:\University_Maps\Anul2\DB\Backup_lab11\device04_exercitiul1.bak'
WITH MOVE 'universitatea' TO 'D:\University_Maps\Anul2\DB\BD_lab11\data.mdf',
MOVE 'Indexes' TO 'D:\University_Maps\Anul2\DB\BD_lab11\data1.ndf',
MOVE 'universitatea_log' TO 'D:\University_Maps\Anul2\DB\BD_lab11\log.ldf',
NORECOVERY
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'D:\University_Maps\Anul2\DB\Backup_lab11\device01_exercitiul2.bak'
WITH 
NORECOVERY
GO
RESTORE LOG universitatea_lab11
FROM DISK = 'D:\University_Maps\Anul2\DB\Backup_lab11\exercitiul3.bak'
WITH NORECOVERY
GO
