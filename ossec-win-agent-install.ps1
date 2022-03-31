# Copyright 2022 KHIKA Technologies Private Limited. All rights reserved.
# This script is written for automation of ossec-agent installation for Windows
# Official ossec site link for downloading source code and other documentation related information is available through the link https://www.ossec.net/download-ossec/

param (
    [Parameter(Mandatory=$true)][string]$server_ip,$device_key
 )

$Logfile = "$PSScriptRoot\ossec-installation.log"
function WriteLog{
    Param ([string]$LogString)
    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $LogMessage = "$Stamp $LogString"
    Add-content $LogFile -value $LogMessage
 }


$elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($elevated -ne 'True'){
     Write-output "You are not Administrator User. You need to Run PowerShell Script in as 'Windows PowerShell ISE with Administrator' to install the ossec-agent"
    break;
    }else{
    
        WriteLog "ossec-agent-win32-3.7.0-24343.exe downloading started"
        $url = "https://updates.atomicorp.com/channels/atomic/windows/ossec-agent-win32-3.7.0-24343.exe"
        $outpath = "$PSScriptRoot/ossec-agent-win32-3.7.0-24343.exe"
        $config = 'C:\Program Files (x86)\ossec-agent\ossec.conf'
        $internalConfig = 'C:\Program Files (x86)\ossec-agent\internal_options.conf'
        $srvName = "OssecSvc"
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($url, $outpath)
        WriteLog "ossec-agent-win32-3.7.0-24343.exe downloading completed"

        WriteLog "ossec-agent installation started"
        Start-Process -Wait -FilePath "$PSScriptRoot/ossec-agent-win32-3.7.0-24343.exe" -ArgumentList "/S" -PassThru
        WriteLog "ossec-agent installation completed"

        (Get-Content -path $internalConfig -Raw) -replace 'logcollector.remote_commands=0','logcollector.remote_commands=1' | Set-Content -Path $internalConfig
        (Get-Content -path $internalConfig -Raw) -replace 'remoted.verify_msg_id=1','remoted.verify_msg_id=0' | Set-Content -Path $internalConfig
        New-Item -Path 'C:\Program Files (x86)\ossec-agent\rids\sender'
        Add-Content $config "`n<ossec_config> <client> <server-ip>$server_ip</server-ip> </client> </ossec_config>"
        Start-Sleep -s 10

        
        # Adding device
        WriteLog "Adding Device, Server_IP:$server_ip device_key:$device_key"
        Write-Output "`r`nAdding Device"
        echo "y" | & "c:\Program Files (x86)\ossec-agent\manage_agents.exe" "-i $device_key" "y`r`n"

        Start-Sleep -s 10
        WriteLog "Device Added"

        WriteLog "Starting service."
        Write-Output "Starting service."
        Start-Service $srvName
        $srvStat = Get-Service $srvName
        Write-Output "$($srvName) is now $($srvStat.status)"
        WriteLog "$($srvName) is now $($srvStat.status)"

        Start-Sleep -s 15

        WriteLog "Restarting service."
        Write-Output "Restarting service."
        Restart-Service $srvName
        $srvStat = Get-Service $srvName
        Write-Output "$($srvName) is now $($srvStat.status)"
        WriteLog "$($srvName) is now $($srvStat.status)"

        Start-Sleep -s 10
        WriteLog "Service started. Now Check logs into UI"
}
