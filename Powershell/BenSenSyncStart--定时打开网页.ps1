## Kill IE IF Exists
$IE = Get-Process iexplore -ErrorAction SilentlyContinue
if($IE)
{
	$IE.Kill()
}
## Open WebSite
Start-Process -FilePath "C:\Program Files\Internet Explorer\iexplore.exe" -ArgumentList http://localhost/BeiSenResume/WebForm1.aspx

## Windows Scheduler:powershell -file "PS1 File Path"