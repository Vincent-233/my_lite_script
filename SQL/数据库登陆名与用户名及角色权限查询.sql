------ ��ѯ����ʵ���������壨��½������������ɫ��
SELECT * FROM sys.server_principals
SELECT * FROM sys.sql_logins
SELECT * FROM sys.syslogins

------ ��ѯ����SQL��½��
SELECT * FROM sys.server_principals WHERE type = 'S'

------ ��ѯ�������ݿ⼶�����壨�û��������ݿ��ɫ��
SELECT * FROM sys.database_principals

------ ��ѯ�������ݿ��û���
SELECT * FROM sys.database_principals WHERE type = 'S' AND sid IS NOT NULL
SELECT * FROM sys.sysusers WHERE issqlrole = 0

------ ��ѯ�û���������Ӧ�ĵ�½�����뵱ǰ���ݿ���أ�
SELECT a.name AS UserName,b.name AS LoginName
FROM sys.database_principals a
LEFT JOIN sys.server_principals b ON a.sid = b.sid
WHERE a.type = 'S' AND a.sid IS NOT NULL

------ ��ѯĳ��½����Ϊ���򷵻����е�½�������ڸ������ݿ���ص��û�������Ϣ���ǳ�ʵ�á�
EXEC sp_helplogins @LoginNamePattern = 'hrsys'

------ ��ѯȨ���б�
SELECT  sys.schemas.name 'Schema'
       ,sys.objects.name Object
       ,sys.database_principals.name username
       ,sys.database_permissions.type permissions_type
       ,sys.database_permissions.permission_name
       ,sys.database_permissions.state permission_state
       ,sys.database_permissions.state_desc
       ,state_desc + ' ' + permission_name + ' on [' + sys.schemas.name + '].[' + sys.objects.name + '] to [' + sys.database_principals.name + ']' COLLATE Latin1_General_CI_AS
FROM    sys.database_permissions
        JOIN sys.objects ON sys.database_permissions.major_id = sys.objects.object_id
        JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id
        JOIN sys.database_principals ON sys.database_permissions.grantee_principal_id = sys.database_principals.principal_id
ORDER BY 'Schema',Object,permissions_type,permission_name

------ ��������ɫ��Ա
SELECT b.name,c.name
FROM sys.server_role_members a
INNER JOIN sys.server_principals b ON a.role_principal_id = b.principal_id
INNER JOIN sys.server_principals c ON a.member_principal_id = c.principal_id

------ ���ݿ��ɫ��Ա
SELECT b.name,c.name
FROM sys.database_role_members a
INNER JOIN sys.database_principals b ON a.role_principal_id = b.principal_id
INNER JOIN sys.database_principals c ON a.member_principal_id = c.principal_id


------ ��ѯ��ǰ�û���Ȩ����
--�ĵ���ַ��https://docs.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-my-permissions-transact-sql?view=sql-server-2017
-- ��ǰ���ݿ���ЧȨ��
select * from sys.fn_my_permissions(NULL, 'DATABASE')

-- ��ǰ��������ЧȨ��
select * from sys.fn_my_permissions(NULL, 'Server')

-- ��ĳ�����Ȩ��
SELECT * FROM fn_my_permissions('Sales.vIndividualCustomer', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;   
	
-- �г���һ���û�����ЧȨ��
EXECUTE AS USER = 'Wanida';  
SELECT * FROM fn_my_permissions('HumanResources.Employee', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

------ ��ѯ�û�Ȩ��
-- List all access provisioned to a sql user or windows user/group directly 
SELECT  
    [UserName] = CASE princ.[type] 
                    WHEN 'S' THEN princ.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE princ.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END,  
    [DatabaseUserName] = princ.[name],       
    [Role] = null,      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],       
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --database user
    sys.database_principals princ  
LEFT JOIN
    --Login accounts
    sys.login_token ulogin on princ.[sid] = ulogin.[sid]
LEFT JOIN        
    --Permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = princ.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col ON col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
WHERE 
    princ.[type] in ('S','U')
UNION
--List all access provisioned to a sql user or windows user/group through a database or application role
SELECT  
    [UserName] = CASE memberprinc.[type] 
                    WHEN 'S' THEN memberprinc.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE memberprinc.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END, 
    [DatabaseUserName] = memberprinc.[name],   
    [Role] = roleprinc.[name],      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],   
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --Role/member associations
    sys.database_role_members members
JOIN
    --Roles
    sys.database_principals roleprinc ON roleprinc.[principal_id] = members.[role_principal_id]
JOIN
    --Role members (database users)
    sys.database_principals memberprinc ON memberprinc.[principal_id] = members.[member_principal_id]
LEFT JOIN
    --Login accounts
    sys.login_token ulogin on memberprinc.[sid] = ulogin.[sid]
LEFT JOIN        
    --Permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col on col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
UNION
--List all access provisioned to the public role, which everyone gets by default
SELECT  
    [UserName] = '{All Users}',
    [UserType] = '{All Users}', 
    [DatabaseUserName] = '{All Users}',       
    [Role] = roleprinc.[name],      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],  
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --Roles
    sys.database_principals roleprinc
LEFT JOIN        
    --Role permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col on col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]                   
JOIN 
    --All objects   
    sys.objects obj ON obj.[object_id] = perm.[major_id]
WHERE
    --Only roles
    roleprinc.[type] = 'R' AND
    --Only public role
    roleprinc.[name] = 'public' AND
    --Only objects of ours, not the MS objects
    obj.is_ms_shipped = 0
ORDER BY
    princ.[Name],
    OBJECT_NAME(perm.major_id),
    col.[name],
    perm.[permission_name],
    perm.[state_desc],
    obj.type_desc--perm.[class_desc] 

