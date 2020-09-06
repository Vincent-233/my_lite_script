CREATE DATABASE [TDEDataBase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TDEDataBase',
  FILENAME = N'C:\MyTest\DB\TDEDataBase.mdf' , 
  SIZE = 3072KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TDEDataBase_log', 
  FILENAME = N'C:\MyTest\DB\TDEDataBase_log.ldf' ,
  SIZE = 1024KB , FILEGROWTH = 10%)
GO

-- Create master key
 CREATE MASTER KEY ENCRYPTION BY PASSWORD = '!drJP9QXC&Vi%cs';
 GO

-- Create the certificate used to protect the database encryption key
 CREATE CERTIFICATE TDETestDBCert WITH SUBJECT = 'TDE Test';
 GO
 
-- Create the database encryption key for TDE.
USE TDEDataBase;

CREATE DATABASE ENCRYPTION KEY 
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE TDETestDBCert;
GO

-- Backup  cert and  keys
BACKUP CERTIFICATE TDETestDBCert
TO FILE = 'C:\MyTest\TDETest_DBCert_BackUp'
WITH PRIVATE KEY
(
FILE = 'C:\MyTest\TDETest_PrivateKeyFile',
ENCRYPTION BY PASSWORD = 'TDETest123'
);
GO

----��������Կ  
BACKUP MASTER KEY   
TO FILE = N'C:\MyTest\MasterKey'     
ENCRYPTION BY PASSWORD = N'password'  
GO 

-- enable TDE
Alter Database TDEDataBase Set Encryption On;

-- �鿴���ܠ�B
 SELECT DB_NAME(database_id) AS DatabaseName,
     key_algorithm AS [Algorithm],
     key_length AS KeyLength,
     CASE encryption_state
         WHEN 0 THEN 'No database encryption key present, no encryption'
         WHEN 1 THEN 'Unencrypted'
         WHEN 2 THEN 'Encryption in progress'
         WHEN 3 THEN 'Encrypted'
         WHEN 4 THEN 'Key change in progress'
         WHEN 5 THEN 'Decryption in progress'
     END AS EncryptionStateDesc,
     percent_complete AS PercentComplete
 FROM sys.dm_database_encryption_keys;
 GO
 

/*
drop CERTIFICATE TDETestDBCert
drop master KEY

*/
 
----------------  Ǩ�Ƶ������ʵ�� �� ɾ��Key���ٻ�ԭ
--  ����Կ����ԭ TDE ���ݿ� ������
USE [master]
RESTORE DATABASE [TDEDataBase] FROM  DISK = N'E:\VirtualBox\Share-VM\TDEDataBase_20180522.bak' WITH  FILE = 2,  NOUNLOAD,  STATS = 5,
MOVE 'TDEDataBase' TO 'E:\DB-File\TDEDataBase.mdf'
,MOVE 'TDEDataBase_Log' TO 'E:\DB-File\TDEDataBase.ldf'

/*
Msg 33111, Level 16, State 3, Line 12
�Ҳ���ָ��Ϊ '0xFA53617842BD3E595188CB993E2E4C84763A54A3' �ķ����� ֤�顣
Msg 3013, Level 16, State 1, Line 12
RESTORE DATABASE �����쳣��ֹ��
*/

-- ��ԭ����Կ
RESTORE MASTER KEY
FROM FILE = N'E:\VirtualBox\Share-VM\Temp\MasterKey'
DECRYPTION BY PASSWORD = N'password'
ENCRYPTION BY PASSWORD = N'password'

-- ������Կ
OPEN MASTER KEY DECRYPTION BY PASSWORD = N'password'

-- ��ԭ֤��
CREATE CERTIFICATE TDETestDBCert
FROM FILE = 'E:\VirtualBox\Share-VM\Temp\TDETest_DBCert_BackUp'
WITH PRIVATE KEY (FILE = 'E:\VirtualBox\Share-VM\Temp\TDETest_PrivateKeyFile', 
DECRYPTION BY PASSWORD = 'TDETest123');

-- �ٴλ�ԭ���ݿ�
RESTORE DATABASE [TDEDataBase] FROM DISK = N'E:\VirtualBox\Share-VM\TDEDataBase_20180522.bak' WITH  FILE = 2,  NOUNLOAD,  STATS = 5,
 MOVE 'TDEDataBase' TO 'E:\DB-File\TDEDataBase.mdf'
,MOVE 'TDEDataBase_Log' TO 'E:\DB-File\TDEDataBase.ldf',REPLACE,RECOVERY
 

/*
ע�⣺��TDE���ܵ����ݿⱸ�ݣ��ڲ�ͬSQL�汾�ķ������ϻ�ԭʱ��������֤�����ԿҲ���ܳ���
-- ���TDE���ܣ�
	Alter Database TDEDataBase Set Encryption OFF;
	drop CERTIFICATE TDETestDBCert
	drop master key
	drop DATABASE ENCRYPTION KEY 
--���ܺ�ı��ݣ��ٻ�ԭ����ͬSQL�汾�ķ�����ʱ��û����

*/



