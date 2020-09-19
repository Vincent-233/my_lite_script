# source and dest
$source = 'D:\Users\Mings\Desktop\Temp\jira_copy\Source'
$dest = 'D:\Users\Mings\Desktop\Temp\jira_copy\Dest'


$project = ls -Dir|Select Name,FullName
$source_jira_folder =  $project|where {$_.Name -match '\b\d+_'}
$source_no_jira_folder = $project|where {$_.Name -notmatch '\b\d+_'}

# folder with jira name: copy all files to jira
foreach($_ in $source_jira_folder)
{
    # create dest folder if not exist
    $folder = $_.Name
    $jira_path = Join-Path $dest ($folder -split '_')[0]
    if (!(Test-Path $jira_path)) {mkdir $jira_path}

    # copy files under folder
    copy "$folder\*" $jira_path -Recurse
}


# folder without jira name: parse jira num and copy
$all_files = ls $source_no_jira_folder.FullName -Recurse|select Name,FullName
foreach($file in $all_files)
{
    # if with jira in file name, copy to jira folder
    $file_name = $file.Name
    if ($file_name -match '\b\d+_')
    {
        $jira_path = Join-Path $dest ($file_name -split '_')[0]
        if (!(Test-Path $jira_path)) {mkdir $jira_path}
        copy $file.FullName $jira_path

    }
    else # no jira, copy to dest root director
    {
        copy $file.FullName $dest
    }
} 