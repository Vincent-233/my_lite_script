$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=X250\sql2014;Database=xxxx;User Id=xxx;Password=xxxx"
$SqlConnection.Open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "SELECT Defination FROM xxx WHERE ID = 106"
$SqlCmd.Connection = $SqlConnection
$FlowIn = $SqlCmd.ExecuteScalar()
$SqlConnection.Close()

$FlowOut = [System.Text.Encoding]::GetEncoding("gb2312").GetString([System.Convert]::FromBase64String($FlowIn))
Set-Content "D:\Users\xxxxx\Desktop\ForTestFlow_Out.xml" $FlowOut