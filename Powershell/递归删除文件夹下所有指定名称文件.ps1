$Path = "Z:\JieDaiBao2"
$Items = Get-ChildItem -Path $Path -Filter *³��ʦ* -Recurse
foreach($_ in $Items)
{
	Write-Host $_.FullName
	Remove-Item $_.FullName
}
Write-Host ("`r`n��ɾ��" + [String]($Items.Count) + "��`r`n")