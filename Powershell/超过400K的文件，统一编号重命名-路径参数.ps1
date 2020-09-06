<#
.Function:
    对某一路径下的文件，若大于400kb，则批量编号并重命名，且加上（换为）jpg后缀，否则将其删除

.Example：
    PS > 此文件名.ps1 -path "E:\Pic\Temp"
    PS > 此文件名.ps1 "E:\Pic\Temp"
    PS > 此文件名.ps1 E:\Pic\Temp

.Typical Usage：
    获取Win10的锁屏壁纸，每台电脑路径不一样，我的壁纸路径如下：
    C:\Users\Mings\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
    可以将其拷贝到另一路径下，然后运行此脚本
#>

param(
    [string] $path
)

$dir = dir $path
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