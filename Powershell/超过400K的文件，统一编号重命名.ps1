# E:\Pic\TempĿ¼�£���400KB���ϵ��ļ�����00001�����Ĺ����������������Ϻ���JPG
# �������ļ���ɾ��
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