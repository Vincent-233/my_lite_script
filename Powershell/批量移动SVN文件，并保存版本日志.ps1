# SVN�ļ����ƶ����½����ļ����£���������־��Ϣ
# ����AAS-Code��Ŀ¼�£��ļ����в��������ű�����sql�ļ���ת�Ƶ��µ��ļ��С�DM�����ֶΡ���
# ˵�������ļ��б����Ѿ�����SVN�汾������ϵ

# �ļ�Ŀ¼
$path = 'D:\AAS\2019-BP\AAS-Code'
# ��ȡ�ļ���
$dir = invoke-expression "dir $path *.sql"

foreach($_ in $dir)
{
	if($_.Name -notmatch "�ű�") 
	{	
		# ·�������ǿո��쳣����ǰ�������
		$oldpath = '"' + $path + '\' + $_.Name + '"'
		$newpath = '"' + $path + '\DM�����ֶ�\' + $_.Name + '"'
		
		# svn��������� svn rename CURR_PATH NEW_PATH
		$cmd = "svn rename $oldpath $newpath"
		
		# ��������
		invoke-expression $cmd
	}
}