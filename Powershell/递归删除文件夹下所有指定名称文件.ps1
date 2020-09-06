$Path = "Z:\JieDaiBao2"
$Items = Get-ChildItem -Path $Path -Filter *鲁大师* -Recurse
foreach($_ in $Items)
{
	Write-Host $_.FullName
	Remove-Item $_.FullName
}
Write-Host ("`r`n共删除" + [String]($Items.Count) + "个`r`n")