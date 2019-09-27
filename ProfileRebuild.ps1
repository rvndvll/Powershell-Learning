$Computer = Read-Host "Enter the computer name, including the L or D."
$user = Read-Host "Enter the name of the user."
$userinfo = Get-AdUser $user -Properties SID,ObjectGUID

#Sends powershell command to remote machine and renames profile to .old, as well as deletes appropriate registry keys
Invoke-Command -ComputerName $Computer -ScriptBlock { 
    
    param($userinfo, $user)

    set-location -path HKLM:\
    $path = "C:\Users\$user"
    $Sid = $userinfo.SID
    $guid = $userinfo.ObjectGUID
    $Profileregistrykey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Sid"
    $Guidregistrykey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileGuid\{$guid}"
        
    Rename-Item -Path $path -NewName "$user.old"
    Remove-Item -Path $Profileregistrykey -Recurse
    Remove-Item -Path $Guidregistrykey -Recurse
   
} -ArgumentList $userinfo,$user

