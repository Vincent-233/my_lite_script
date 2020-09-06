# 功能：递归拷贝某目录下文件，排除根目录下的文件 

$source = "D:\OneDrive"
$destination = "E:\OneDrive_Sync"
$file = "*.*"
$robocopyOptions = @('/E') # 用数组传参数,/E代表 copy subdirectories, including Empty ones

$dir = Get-ChildItem $source -Directory # 仅拷贝目录
foreach($_ in $dir)
{
    $_source = Join-Path $source  $_.Name
    $_destination = Join-Path $destination  $_.Name

	robocopy @($_source, $_destination , $file) + $robocopyOptions >> E:\OneDrive_Sync\Sync_log.log
}

# 原始CMD命令： robocopy "D:\OneDrive\考试与认证\MCSA&MCSE\70-462" "E:\OneDrive_Sync\70-462" /E
# 可用/L参数，仅列出，不执行Copy来检查命令
# @()表示数组