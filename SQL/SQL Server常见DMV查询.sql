-- 查询 Session 正在执行的SQL
-- Running Query
SELECT req.session_id
    ,s.login_time
    ,req.start_time
    ,req.total_elapsed_time
    ,req.total_elapsed_time / 1000.0 / 60.0 AS total_eplapsed_minutes
    ,req.STATUS
    ,req.command
    ,req.database_id
    ,req.last_wait_type
    ,req.wait_resource
    ,req.blocking_session_id AS blocking_by_session_id
    ,db.name AS [database]
    ,object_name(st.objectid, st.[dbid]) 'ObjectName'
    ,s.login_name
    ,s.host_name
    ,s.program_name
    ,s.client_version
    ,s.nt_user_name
    ,req.open_transaction_count
    ,req.estimated_completion_time
    ,DATALENGTH(ST.TEXT) AS statement_length
    ,req.statement_start_offset
    ,req.statement_end_offset
    ,st.TEXT
    ,SUBSTRING(ST.TEXT, (req.statement_start_offset / 2) + 1, (
            (
                CASE statement_end_offset
                    WHEN - 1
                        THEN DATALENGTH(ST.TEXT)
                    ELSE req.statement_end_offset
                    END - req.statement_start_offset
                ) / 2
            ) + 1) AS statement_text
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS st
LEFT JOIN sys.databases db ON req.database_id = db.database_id
LEFT JOIN sys.dm_exec_sessions s ON req.session_id = s.session_id;


-- blocked 为为阻塞当前会话的进程
select * from sys.sysprocesses where blocked <> 0 and blocked <> spid

-- blocking_session_id 为阻塞当前会话 的进程
select * from sys.dm_exec_requests where blocking_session_id <> 0


-- 等待资源
SELECT es.session_id
       ,DB_NAME(er.database_id) AS [database_name]
       ,OBJECT_NAME(qp.objectid,qp.dbid) AS [object_name]
       , -- NULL if Ad-Hoc or Prepared statements
       er.wait_type
       ,er.wait_resource
       ,er.status
       ,(SELECT CASE
                  WHEN pageid = 1 OR pageid % 8088 = 0 THEN 'Is_PFS_Page'
                  WHEN pageid = 2 OR pageid % 511232 = 0 THEN 'Is_GAM_Page'
                  WHEN pageid = 3 OR (pageid - 1) % 511232 = 0 THEN 'Is_SGAM_Page'
                  WHEN pageid IS NULL THEN NULL
                  ELSE 'Is Not PFS, GAM or SGAM page'
                END 
         FROM (SELECT CASE
                        WHEN er.[wait_type] LIKE 'PAGE%LATCH%' AND er.[wait_resource] LIKE '%:%' THEN CAST(RIGHT (er.[wait_resource],LEN (er.[wait_resource]) - CHARINDEX (':',er.[wait_resource],LEN (er.[wait_resource]) - CHARINDEX (':',REVERSE (er.[wait_resource])))) AS INT)
                        ELSE NULL
                      END AS pageid) AS latch_pageid) AS wait_resource_type
       ,er.wait_time AS wait_time_ms
       ,(SELECT qt.TEXT AS [text()]
         FROM sys.dm_exec_sql_text (er.sql_handle) AS qt 
         FOR XML PATH (''),TYPE) AS [running_batch]
       ,(SELECT SUBSTRING(qt2.TEXT,(CASE WHEN er.statement_start_offset = 0 THEN 0 ELSE er.statement_start_offset / 2 END),(CASE WHEN er.statement_end_offset = -1 THEN DATALENGTH(qt2.TEXT) ELSE er.statement_end_offset / 2 END-(CASE WHEN er.statement_start_offset = 0 THEN 0 ELSE er.statement_start_offset / 2 END))) AS [text()]
         FROM sys.dm_exec_sql_text (er.sql_handle) AS qt2 
         FOR XML PATH ('') ,TYPE) AS [running_statement]
       ,qp.query_plan
FROM sys.dm_exec_requests er
  LEFT OUTER JOIN sys.dm_exec_sessions es ON er.session_id = es.session_id
  CROSS APPLY sys.dm_exec_query_plan (er.plan_handle) qp
WHERE er.session_id <> @@SPID
AND   es.is_user_process = 1
ORDER BY er.total_elapsed_time DESC
         ,er.logical_reads DESC
         ,[database_name]
         ,session_id;

