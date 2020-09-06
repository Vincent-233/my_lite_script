# 删除7天以前的文件
$limit = (Get-Date).AddDays(-7)
$path = "D:\kayangDTS\Out\BI"
Get-ChildItem -Path $path | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item