--------- 可以前台做成gantt图
SELECT
    a.computer
   ,a.operator
   ,a.source
   ,a.sourceid
   ,a.executionid
   ,a.starttime
   ,b.endtime
   ,DATEDIFF(SECOND, a.starttime, b.endtime) AS [duration(s)]
   ,CAST(ROUND(DATEDIFF(SECOND, a.starttime, b.endtime)/60.0,2) AS DECIMAL(18,2))  AS [duration(min)]
FROM dgt.dbo.sysssislog a
INNER JOIN dgt.dbo.sysssislog b
    ON a.source = b.source
        AND a.executionid = b.executionid
        AND a.event = 'OnPreExecute'
        AND b.event = 'OnPostExecute'
WHERE a.sourceid IN
(
      '264EE547-0613-4FF3-90CB-0A5FF9499CCF'
    , '937B715D-C18A-4F47-9077-22B22151A2FF'
    , '8C75D454-0705-4452-BE82-319D7821B54C'
    , '3AF2E5B0-1DF8-42EA-8FA4-6560BDEB4243'
    , 'B1D389F8-8901-4563-BDDE-A2A4F8E5A5B8'
    , 'DAE26F4C-5C7D-465E-8C8F-D4471907D066'
    , '95174EBA-A484-4A71-9AAB-EC0695A1D1FA'
    , 'EC994B18-B8E9-4B30-A6CF-F86F3EC5CE76'
)
