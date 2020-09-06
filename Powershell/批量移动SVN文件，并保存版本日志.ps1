# SVN文件，移动到新建的文件夹下，并保存日志信息
# 需求：AAS-Code根目录下，文件名中不包含“脚本”的sql文件，转移到新的文件夹“DM增加字段”中
# 说明：新文件夹必须已经进入SVN版本管理体系

# 文件目录
$path = 'D:\AAS\2019-BP\AAS-Code'
# 获取文件名
$dir = invoke-expression "dir $path *.sql"

foreach($_ in $dir)
{
	if($_.Name -notmatch "脚本") 
	{	
		# 路径，考虑空格异常，故前后加引号
		$oldpath = '"' + $path + '\' + $_.Name + '"'
		$newpath = '"' + $path + '\DM增加字段\' + $_.Name + '"'
		
		# svn重命名命令： svn rename CURR_PATH NEW_PATH
		$cmd = "svn rename $oldpath $newpath"
		
		# 调用命令
		invoke-expression $cmd
	}
}