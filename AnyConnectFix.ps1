$user = (Get-WmiObject -Class Win32_Process -Filter 'Name="explorer.exe"').GetOwner().User
$path = "C:\Users\$user\AppData\Local\Cisco\Cisco AnyConnect Secure Mobility Client\preferences.xml"
$location = "C:\Users\$user\AppData\Local\Cisco\Cisco AnyConnect Secure Mobility Client"

function Update-User
{
   $xml = Get-Content $path
   $xml | % { $_.Replace("rtmay", $user) } | Set-Content $path
}

if (![System.IO.File]::Exists($path))
{
    
    Copy-Item -Path "\\daycs01\csshare$\CS_tools\AnyConnect_Files\*" -Destination $location
    Update-User
    Write-Host "Files added. Please restart the computer to apply changes."
    Restart-Computer -Confirm:$true
} else {
    
    Update-User
    write-host "Preferences updated. Please restart the computer to apply changes."
    Restart-Computer -Confirm:$true
   
    }



