# ɾ��7����ǰ���ļ�
$limit = (Get-Date).AddDays(-7)
$path = "D:\kayangDTS\Out\BI"
Get-ChildItem -Path $path | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item