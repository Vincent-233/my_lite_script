﻿<#
Source:
	+--- 123213_task_2
	|   +--- script_1.sql
	|   +--- script_2.sql
	|   +--- task_1.sql
	+--- 143455_task_3
	|   +--- script 1.sql
	|   +--- script 2.sql
	+--- other_task
	|   +--- 21432_script 4.sql
	|   +--- 46514_script 3.sql
	|   +--- 56435_script 2.sql
	|   +--- dsfafafdsafda.sql
	|   +--- script 1.sql

Dest:
	+--- 123213
	|   +--- script_1.sql
	|   +--- script_2.sql
	|   +--- task_1.sql
	+--- 143455
	|   +--- script 1.sql
	|   +--- script 2.sql
	+--- 21432
	|   +--- 21432_script 4.sql
	+--- 46514
	|   +--- 46514_script 3.sql
	+--- 56435
	|   +--- 56435_script 2.sql
	+--- dsfafafdsafda.sql
	+--- script 1.sql
#>

# source and dest
$source = 'D:\Users\xxxx\Desktop\Temp\jira_copy\Source'
$dest = 'D:\Users\xxxx\Desktop\Temp\jira_copy\Dest'


$project = ls $source -Dir|Select Name,FullName
$source_jira_folder =  $project|where {$_.Name -match '\b\d+_'}
$source_no_jira_folder = $project|where {$_.Name -notmatch '\b\d+_'}

# folder with jira name: copy all files to jira
foreach($_ in $source_jira_folder)
{
    # create dest folder if not exist
    $folder = $_.FullName
    $jira_path = Join-Path $dest ($_.Name -split '_')[0]
    if (!(Test-Path $jira_path)) {mkdir $jira_path}

    # copy files under folder
    copy "$folder\*" $jira_path -Recurse -Force
}


# folder without jira name: parse jira num and copy
$all_files = ls $source_no_jira_folder.FullName -Recurse -File|select Name,FullName
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