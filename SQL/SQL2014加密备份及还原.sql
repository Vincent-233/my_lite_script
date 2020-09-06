use master  
go  
--1.���ݲ��� 
--��������Կ  
create master key encryption by password = N'Hello@MyMasterKey'  
go  
  
--����֤��  
create certificate Mycertificate    
with subject = N'EnryptData certificate',    
start_date = N'20160101',    
expiry_date = N'20990101';    
go    
--��������Կ  
backup master key   
to file = N'H:\Database\master_SMK1.key'     
encryption by password = N'Hello@MyMasterKey'  
go  

--����֤���˽Կ  
backup certificate Mycertificate     
to file = N'H:\Database\Mycertificate.cer' --���ڼ��ܵ�֤�鱸��·��    
with private key (     
    file = N'H:\Database\Mycertificate_saleskey.pvk' ,--���ڽ���֤��˽Կ�ļ�·��     
    encryption by password = N'Hello@Mycertificate' );--��˽Կ���м��ܵ�����    
go  

--֤����ܱ������ݿ�  
backup database PB  
to disk = N'h:\database\pb.bak'    
with    
    compression, stats = 10,   
    encryption     
    (    
    algorithm = aes_256,    
    server certificate = mycertificate    
    )  
go    
  
---2.���������ԭ������������ʡ��Կ��֤�黹ԭ����
--��ԭ����Կ  
USE master  
GO  
RESTORE MASTER KEY  
FROM FILE = N'h:\database\master_SMK1.key'  
DECRYPTION BY PASSWORD = N'Hello@MyMasterKey'  
ENCRYPTION BY PASSWORD = N'Hello@MyMasterKey' FORCE  
GO  
  
/*��ԭ����,��ʵ���ķ��������˻�������ͬ������������´���  
  
��Ϣ 15317������ 16��״̬ 2���� 22 ��  
����Կ�ļ������ڻ��ʽ��Ч��  
The master key file does not exist or has invalid format  
*/  
  
  
--����Կ  
OPEN MASTER KEY DECRYPTION BY PASSWORD = N'Hello@MyMasterKey'  
GO  
  
--��ԭ֤��  
CREATE CERTIFICATE Mycertificate     
FROM FILE = N'h:\database\Mycertificate.cer'     
WITH PRIVATE KEY (    
    FILE = N'h:\database\Mycertificate_saleskey.pvk',     
    DECRYPTION BY PASSWORD = 'Hello@Mycertificate');    
GO  
  
  
-- �ٻ�ԭ���ݿ⣬������  
USE [master]  
GO  
RESTORE DATABASE PB1  
FROM  DISK = N'h:\database\PB.bak'   
WITH  FILE = 1,  
MOVE N'HRE6IES_Data' TO N'h:\database\PB1.mdf', 
MOVE N'HRE6IES_Log' TO N'h:\database\PB_log.ldf',    
NOUNLOAD,  STATS = 5  
GO  

  
