-- ����
bcp AdventureWorks2012.HumanResources.Department OUT D:\Department.txt -c -T -t\t

-- ��������ѯ queryout��
bcp "SELECT * FROM DBName.dbo.aBalance WHERE ExpiredDate > '20180501'" queryout D:\aBalance.txt -c -t\t -S 172.28.11.195 -U hrsys -P hrsystem

-- ���루�޸�ʽ�ļ���
bcp AdventureWorks2012.dbo.Department_Copy IN D:\Department.txt -c -T -t\t

-- ���루���Ա�ͷ���ܵ����ָ����ӵڶ��п�ʼ���룩
bcp DTC.dbo.stage_Dig_Kids_MLP_Attribute IN C:\Users\bming\Documents\Working\df_DIG_Kids.csv -c -T -t"|" -S p7wsql00011\BI -F 2

-- ���� ��ʽ�ļ�
bcp AdventureWorks2012.HumanResources.Department format nul -f D:\TestFormatFile.xml -c -x -T

--  ��ʽ�ļ����� ��bcp��
bcp AdventureWorks2012.dbo.Department_Test in D:\Department.txt -f D:\TestFormatFile.xml -T

-- ���뵽Զ�̷�������bcp ����ʽ�ļ���
bcp TestDB.dbo.Department_Test in D:\Department.txt -f D:\TestFormatFile.xml -S WIN-4GK864H3VSS\SQL2012,1433 -U sa -P benjay@123

-- ����Զ�̷��������޸�ʽ�ļ���
bcp YFAI_KYBPMUAT.dbo.Department_Copy IN D:\Department.txt -c -t\t -S 172.28.13.230,4122,1433 -U kayang_owner -P tstDSD!324dssaf

-- ��ʽ�ļ����루Bulk Insert��
BULK INSERT AdventureWorks2012.dbo.Department_Test
FROM 'D:\Department.txt'
WITH (FORMATFILE = 'D:\TestFormatFile.xml');

-- Nike ����ģ��
bcp {target_table} in {file_path} -c -T -t"|" -S {server_name} -F 2

-- ����UTF-8��������ݣ�-C 65001 ָ UTF8
-- Versions prior to version 13 (SQL Server 2016 (13.x)) do not support code page 65001 (UTF-8 encoding). 
-- Versions beginning with 13 can import UTF-8 encoding to earlier versions of SQL Server.
bcp DGT.dbo.Consumer_TMall in C:\Users\bming\Documents\VM-Share\consumer.csv -c -T -t, -S p7wsql00011\BI -F 2 -C 65001



-- ��ʽ�ļ���Record��ʾ�����ļ����У�Row��ʾ���ݿ��Ӧ�����
/*
<?xml version="1.0"?>
<BCPFORMAT xmlns="http://schemas.microsoft.com/sqlserver/2004/bulkload/format" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <RECORD>
  <FIELD ID="1" xsi:type="CharTerm" TERMINATOR="\t" MAX_LENGTH="7"/>
  <FIELD ID="2" xsi:type="CharTerm" TERMINATOR="\t" MAX_LENGTH="100" COLLATION="SQL_Latin1_General_CP1_CI_AS"/>
  <FIELD ID="3" xsi:type="CharTerm" TERMINATOR="\t" MAX_LENGTH="100" COLLATION="SQL_Latin1_General_CP1_CI_AS"/>
  <FIELD ID="4" xsi:type="CharTerm" TERMINATOR="\r\n" MAX_LENGTH="24"/>
 </RECORD>
 <ROW>
  <COLUMN SOURCE="1" NAME="DepartmentID" xsi:type="SQLSMALLINT"/>
  <COLUMN SOURCE="2" NAME="Name" xsi:type="SQLNVARCHAR"/>
  <!-- <COLUMN SOURCE="3" NAME="GroupName" xsi:type="SQLNVARCHAR"/> -->
  <COLUMN SOURCE="4" NAME="ModifiedDate" xsi:type="SQLDATETIME"/>	
 </ROW>
</BCPFORMAT>
*/

--------- ���ظ�ʽ��������չ�ֶλ�˫�ֽ��ַ���ǰ���¿��ã����������ٶȣ�
-- export to a native file 
bcp test_db.dbo.physcial_checkup out D:\Users\xxxx\Desktop\Temp\2014-Medical-native.dat -S xxx -n -T
-- import a native file
bcp test_db.dbo.physcial_checkup in D:\Users\xxxx\Desktop\Temp\2014-Medical-native.dat -S xxx -n -T

