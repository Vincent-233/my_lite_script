# ���ܣ��ݹ鿽��ĳĿ¼���ļ����ų���Ŀ¼�µ��ļ� 

$source = "D:\OneDrive"
$destination = "E:\OneDrive_Sync"
$file = "*.*"
$robocopyOptions = @('/E') # �����鴫����,/E���� copy subdirectories, including Empty ones

$dir = Get-ChildItem $source -Directory # ������Ŀ¼
foreach($_ in $dir)
{
    $_source = Join-Path $source  $_.Name
    $_destination = Join-Path $destination  $_.Name

	robocopy @($_source, $_destination , $file) + $robocopyOptions >> E:\OneDrive_Sync\Sync_log.log
}

# ԭʼCMD��� robocopy "D:\OneDrive\��������֤\MCSA&MCSE\70-462" "E:\OneDrive_Sync\70-462" /E
# ����/L���������г�����ִ��Copy���������
# @()��ʾ����