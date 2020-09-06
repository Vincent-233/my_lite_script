<#
.Function:
    ��ĳһ·���µ��ļ���������400kb����������Ų����������Ҽ��ϣ���Ϊ��jpg��׺��������ɾ��

.Example��
    PS > ���ļ���.ps1 -path "E:\Pic\Temp"
    PS > ���ļ���.ps1 "E:\Pic\Temp"
    PS > ���ļ���.ps1 E:\Pic\Temp

.Typical Usage��
    ��ȡWin10��������ֽ��ÿ̨����·����һ�����ҵı�ֽ·�����£�
    C:\Users\Mings\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
    ���Խ��俽������һ·���£�Ȼ�����д˽ű�
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