$arr = get-content e:\stShrinkage.txt -encoding Unicode
[System.Collections.ArrayList]$arraylist = $arr
foreach($str in $arr)
{
	if($str.Substring(0,1) -eq "`t")
	{
		$arraylist.Remove($str)
	}
}
set-content e:\stShrinkage.txt -encoding Unicode $arraylist

