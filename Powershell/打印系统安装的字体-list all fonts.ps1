# ����ģ��/��
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

# ��ӡ����
(New-Object System.Drawing.Text.InstalledFontCollection).Families
 
# ����
(New-Object System.Drawing.Text.InstalledFontCollection).Families|where-object{$_.Name -like '*mono*'}