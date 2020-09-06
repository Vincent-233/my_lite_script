$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=X250\sql2014;Database=SHBank0927;User Id=hrsys;Password=hrsystem"
$SqlConnection.Open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "SELECT Defination FROM skywfflow WHERE ID = 106"
$SqlCmd.Connection = $SqlConnection
$FlowIn = $SqlCmd.ExecuteScalar()
$SqlConnection.Close()

$FlowOut = [System.Text.Encoding]::GetEncoding("gb2312").GetString([System.Convert]::FromBase64String($FlowIn))
Set-Content "D:\Users\Mings\Desktop\ForTestFlow_Out.xml" $FlowOut