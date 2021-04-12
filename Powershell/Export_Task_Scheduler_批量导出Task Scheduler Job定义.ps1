$task_path = '\Microsoft\Office'
Get-ScheduledTask -TaskPath "$task_path\*"|
ForEach-Object {
	Export-ScheduledTask -TaskPath $task_path -TaskName $_.TaskName > D:\Users\xxxx\Desktop\Temp\$($_.TaskName).xml
}