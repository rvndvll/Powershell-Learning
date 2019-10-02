    #Opens PowerShell in Administrator 
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

    {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
    }

    Write-Host "   _________            __     _____            __                      " 
    Write-Host "  / ____/ (_)__  ____  / /_   / ___/__  _______/ /____  ____ ___  _____ "  
    Write-Host " / /   / / / _ \/ __ \/ __/   \__ \/ / / / ___/ __/ _ \/ __ `__ \/ ___/ " 
    Write-Host "/ /___/ / /  __/ / / / /_    ___/ / /_/ (__  ) /_/  __/ / / / / (__  )  " 
    Write-Host "\____/_/_/\___/_/ /_/\__/   /____/\__, /____/\__/\___/_/ /_/ /_/____/   " 
    Write-Host "    ____             _____ __    /_______       __          _ __    __  " 
    Write-Host "   / __ \_________  / __(_) /__     / __ \___  / /_  __  __(_) /___/ /  " 
    Write-Host "  / /_/ / ___/ __ \/ /_/ / / _ \   / /_/ / _ \/ __ \/ / / / / / __  /   " 
    Write-Host " / ____/ /  / /_/ / __/ / /  __/  / _, _/  __/ /_/ / /_/ / / / /_/ /    " 
    Write-Host "/_/   /_/   \____/_/ /_/_/\___/  /_/ |_|\___/_.___/\__,_/_/_/\__,_/     " 
    Write-Host " "
    Write-Host "      Or: How I Learned to Stop Worrying and Love Dad Jokes"
    Write-Host " "
    Write-Host -ForegroundColor Green "Version 1.0 (10/1/2019)"
    Write-Host -ForegroundColor Red "Warning: Ensure that all inputs are correct."
    Write-Host " "
    Write-Host " "


    $Computer = Read-Host "Enter the computer name, including the L or D."
    $user = Read-Host "Enter the name of the user."
    $userinfo = Get-AdUser $user -Properties SID,ObjectGUID
    $path = "C:\Users\$user"
    $ComputerPing = $false
    $Online = $false

    #Tests Computer Connections
    Write-Host " "
    Write-Host "-------Checking to see if the computer is online.  Just a moment.-------`n"
    $ComputerPing = Test-Connection -computer $Computer -quiet

    #if computer is online
    if ($ComputerPing -eq $true){
    Write-Host -ForegroundColor Green "The computer is online."
    $Online = $true
    }

    if ($ComputerPing -eq $false){
    Write-Host -ForegroundColor Red "Warning: $Computer isn't online. Press enter to close the script.`n"
    pause
    Exit
    }

    #Starts the WinRM service 
    Get-Service -Name WinRM -ComputerName $Computer | Set-Service -Status Running  

    #Sends powershell command to remote machine and renames profile to .old, as well as deletes appropriate registry keys
    Invoke-Command -Computer $Computer -ScriptBlock { 
    
    param($userinfo, $user)

    $path = "C:\Users\$user"
    $Sid = $userinfo.SID
    $guid = $userinfo.ObjectGUID
    set-location -path HKLM:\
    $Profileregistrykey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Sid"
    $Guidregistrykey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileGuid\{$guid}"

    Rename-Item -Path $path -NewName "$user.old"
    #Remove-Item -Path $Profileregistrykey -Recurse
    #Remove-Item -Path $Guidregistrykey -Recurse
   
    } -ArgumentList $userinfo,$user


    pause
