# No1 BCP�����������ݽӿ��ļ��������ں�׺
$Date = (Get-Date).ToString("yyyyMMdd")
invoke-expression "bcp sephora.dbo.Interface_VW_Attendance out D:\kayangDTS\Out\BI\BI_Store_Attendance_$Date.csv -w -SSAS-SH1WPHRS1 -Uhrsys -Phrsystem"

# No2 BCP����HeadCount���ݽӿ��ļ��������ں�׺
$Date = (Get-Date).ToString("yyyyMMdd")
invoke-expression "bcp `"Select * from sephora.dbo.Interface_VW_HeadCount ORDER BY CASE WHEN ISDATE(Term) = 0 THEN `'1900-01-01`' ELSE Term END,DepID,JobID`" queryout D:\kayangDTS\Out\BI\BI_Store_HeadCount_$Date.csv -w -SSAS-SH1WPHRS1 -Uhrsys -Phrsystem"