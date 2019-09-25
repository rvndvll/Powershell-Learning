Import-Module ActiveDirectory 
# Site configuration
$SiteCode = "C01" # Site code 
$ProviderMachineName = "serverblahblah.corp" # SMS Provider machine name

function Show-Menu
{
    param (
        [string]$Title = 'I REALLY HATE Dad Jokes'
    )
    Clear-Host
    Write-Host "================ $Title ================`n"
    
    Write-Host "1: Press '1' for user information."
    Write-Host "2: Press '2' for computer information."
    Write-Host "3: Press '3' to enable/change OU of device."
    Write-Host "4: Press '4' to add a user to a VDI group."
    Write-Host "Q: Press 'Q' to quit.`n"
    Write-Host "========================================================="
}

function User-Information
{
    $user = Read-Host "Type the name of the user"
    $userInfo = Get-AdUser $user -Properties *
    $name = $userInfo.name
    $location = $userInfo.physicalDeliveryOfficeName
    $mail = $userInfo.mail
    $sip = $userInfo."msRTCSIP-PrimaryUserAddress"
    $enabled = $userInfo.enabled
    $passwordLastSet = net user $user /domain | find "Password last set"
    $passwordExpires = net user $user /domain | find "Password expires"
 
    Write-Host 'Name                        '$name
    Write-Host 'Location                    '$location
    Write-Host 'Email                       '$mail
    Write-Host 'SIP                         '$sip
    Write-Host 'Enabled                     '$enabled
    Write-Host $passwordLastSet
    Write-Host $passwordExpires  
}

function Computer-Information
{
    $device = Read-Host "Type the name of the device including the L or D"
    $deviceInfo = Get-ADComputer $device -Properties *
    $OU = $deviceInfo.DistinguishedName
    $operatingSystem = $deviceInfo.OperatingSystem
    $enabled = $deviceInfo.Enabled

    Write-Host 'OU:      '$OU
    Write-Host 'OS:      '$operatingSystem
    Write-Host 'Enabled: '$enabled
}

function Enable-Machine
{
    $device = Read-Host "Type the name of the device including the L or D"

    Write-Host "1: Press '1' to add to the Windows 7 OU."
    Write-Host "2: Press '2' to add to the Windows 10 OU."

    $selection = Read-Host "Please make a selection."
    switch ($selection)
    {
        '1' {
           Get-ADComputer $device | Move-ADObject -TargetPath "OU=Workstations,DC=CareSource,DC=corp"
      } '2' {
           Get-ADComputer $device | Move-ADObject -TargetPath "OU=Windows10,OU=Workstations,DC=CareSource,DC=corp"
      }
     }  
        
     Get-ADComputer $device | Enable-ADAccount 
     Write-Host "The device has been enabled, and has been moved to the selected OU."
    }

function Add-VDI
{
    $vdiuser = Read-Host "Type the name of the user"
    
    Write-Host "`n1: VDI_CAG"
    Write-Host "2: VDI_CareSource2"
    Write-Host "3: VDI_CSU"
    Write-Host "4: VDI_Delegate"
    Write-Host "5: VDI_Developer"
   

    $vdi = Read-Host "Which VDI group you would like to assign?"
    switch ($vdi)
    {
        '1' {
            Add-ADGroupMember -identity "VDI_CAG" -members $vdiuser
        }
        '2'{
            Add-ADGroupMember -identity "VDI_CareSource2" -members $vdiuser
        }
        '3'{
            Add-ADGroupMember -Identity "VDI_CSU" -members $vdiuser
        }
        '4'{
            Add-ADGroupMember -identity "VDI_Delegate" -members $vdiuser
        }
        '5'{
            Add-ADGroupMember -identity "VDI_Developer" -members $vdiuser
        }

    }
}

#Menu choices
do
 {
     Show-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
           '1' {
             User-Information
         } '2' {
             Computer-Information
         } '3' {
             Enable-Machine
         } '4' {
             Add-VDI
         }
     }
     pause
 }
 until ($selection -eq 'q')

