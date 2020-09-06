# E:\Pic\Temp目录下，对400KB以上的文件，以00001这样的规则重命名，并加上后续JPG
# 其它的文件，删除
$dir = dir E:\Pic\Temp
$No = 1
foreach($_ in $dir)
{
	if(!$_.PSIsContainer)
	{
		if($_.Length -ge 400kb)
		{
			$Name = '0000' + $No.ToString()
			Rename-Item $_.FullName -NewName ($Name.Substring($Name.Length - 4) + '.jpg')
			$No++
		}
		else
		{
			Remove-Item $_.FullName
		}
	}
}