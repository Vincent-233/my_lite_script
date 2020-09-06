# 引入模块/类
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

# 打印属性
(New-Object System.Drawing.Text.InstalledFontCollection).Families
 
# 过滤
(New-Object System.Drawing.Text.InstalledFontCollection).Families|where-object{$_.Name -like '*mono*'}