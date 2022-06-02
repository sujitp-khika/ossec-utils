# Copyright 2022 KHIKA Technologies Private Limited. All rights reserved.
# This script is written for automation of ossec-agent installation for Windows
# Official ossec site link for downloading source code and other documentation related information is available through the link https://www.ossec.net/download-ossec/

param (
    [Parameter(Mandatory=$true)][string]$server_ip,$device_key
)

$Logfile = "$PSScriptRoot\ossec-win-agent-installation.log"
function WriteLog{
    Param ([string]$LogString)
    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $LogMessage = "$Stamp $LogString"
    Add-content $LogFile -value $LogMessage
}

function restart_agent_verify{
    Write-Output "Hardening audit logs not found"
    WriteLog "Hardening audit logs not found"
    Write-Output "`r`nTrying to connect server after restart"
    WriteLog "Trying to connect server after restart"
    Write-Output "`r`nRestarting ossec-agent service."
    WriteLog "Restarting ossec-agent service."
    Restart-Service $srvName
    $srvStat = Get-Service $srvName
    Write-Output "Ossec-agent is $($srvStat.status)"
    WriteLog "Ossec-agent is $($srvStat.status)" 
    Write-Output "Waiting for 30s"
    WriteLog "Waiting for 30s"
    Start-Sleep -s 30

    $connect_server = Get-Content $osseclog | ? {($_ | Select-String "Connected to server")}
    $last_powershellCommand = Get-Content $osseclog | ? {($_ | Select-String "NetFirewallProfile")}
    $refrence_DateTime = (Get-Date).AddMinutes(-5).ToString("yyyy/MM/dd HH:mm")
    WriteLog "connect_server=$connect_server"
    WriteLog "last_powershellCommand=$last_powershellCommand"
    
    foreach ($lastline_ServerData in $connect_server){}
    $connectedServer_Data = $($lastline_ServerData -split('\s+'))[0,1]
    $connectedServer_DateTime = [System.String]::Join(" ",$connectedServer_Data)
        if ($connectedServer_DateTime -eq " "){
            Write-Output "`r`nAgent Failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            WriteLog "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            break;
            }
        if((Get-Date $refrence_DateTime) -lt (Get-Date $connectedServer_DateTime)){
            Write-Output "`r`nAgent is connected to Server"
            WriteLog "Agent is connected to Server"
        }else{
            Write-Output "`r`nAgent failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            WriteLog "Agent failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file" 
            break;
            }

    foreach ($lastline_command in $last_powershellCommand){}
    $lastCommand_Data = $($lastline_command -split('\s+'))[0,1]
    $lastCommand_DateTime = [System.String]::Join(" ",$lastCommand_Data)
        if (-not($lastCommand_DateTime -eq " ")){
            if((Get-Date $refrence_DateTime) -lt (Get-Date $lastCommand_DateTime)){
                Write-Output "Hardening audit logs found`r`n"
                WriteLog "Hardening audit logs found"
            }else{
                Write-Output "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file`r`n"
                WriteLog "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
                }
        }else{
            Write-Output "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file`r`n"
            WriteLog "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            }
    }

function verify_installation{
    $osseclog = 'C:\Program Files (x86)\ossec-agent\ossec.log'
    $connect_server = Get-Content $osseclog | ? {($_ | Select-String "Connected to server")}        
    $last_powershellCommand = Get-Content $osseclog | ? {($_ | Select-String "NetFirewallProfile")}
    $refrence_DateTime = (Get-Date).AddMinutes(-5).ToString("yyyy/MM/dd HH:mm")
    WriteLog "connect_server=$connect_server"
    WriteLog "last_powershellCommand=$last_powershellCommand"

    foreach ($lastline_ServerData in $connect_server){}
    $connectedServer_Data = $($lastline_ServerData -split('\s+'))[0,1]
    $connectedServer_DateTime = [System.String]::Join(" ",$connectedServer_Data)
        if ($connectedServer_DateTime -eq " "){
            Write-Output "`r`nAgent Failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            WriteLog "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            break;
        }
        if((Get-Date $refrence_DateTime) -lt (Get-Date $connectedServer_DateTime)) {
            Write-Output "`r`nAgent is connected to Server"
            WriteLog "Agent is connected to Server"
        }else{
            Write-Output "`r`nAgent Failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            WriteLog "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-win-agent-installation.log file"
            break;
        }

    foreach ($lastline_command in $last_powershellCommand){}
    $lastCommand_Data = $($lastline_command -split('\s+'))[0,1]
    $lastCommand_DateTime = [System.String]::Join(" ",$lastCommand_Data)
        if (-not($lastCommand_DateTime -eq " ")){
            if((Get-Date $refrence_DateTime) -lt (Get-Date $lastCommand_DateTime)){
                Write-Output "Hardening audit logs found`r`n"
                WriteLog "Hardening audit logs found"
            }else{
                restart_agent_verify
                }
        }else{
            restart_agent_verify
            }        
}

function agent_already_installed{
    $ossec_service = Get-Service "OssecSvc*"|select Name
    $service_name = $ossec_service.Name
        if($service_name -eq "OssecSvc"){
            Write-Host "`r`nOSSEC-HIDS agent is already installed. Please uninstall the OSSEC-HIDS agent for automated installation process to continue.`r`n"
            break;
        }else{
            Write-Host "`r`nOSSEC-HIDS agent automated installation process will start now.`r`n"
            WriteLog "`r`nOSSEC-HIDS agent automated installation process will start now.`r`n"
            }
}

$elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($elevated -ne 'True'){
    Write-Output "You are not Administrator User. You need to Run PowerShell Script in as 'Windows PowerShell with Administrator' to install the ossec-agent"
    break;
    }else{
        Write-Output "*************************************************************************************"
		WriteLog "Starting automated installation"
		Write-Output "** Starting automated installation"
		Write-Output "** Note: Do not press any key - this is automated installation"
        Write-Output "** Note: Installation process may take 3-5 minutes to complete"
        Write-Output "** Note: Please ignore any message: 'manage_agents: Input too large. Not adding it.'"
        Write-Output "*************************************************************************************"
        #Already agent installed check function call
        agent_already_installed
        #Automated ossec-agent installation process starts from here
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
		
		$installation_path = 'C:\Program Files (x86)\ossec-agent'
		if (Test-Path -Path $installation_path ){	
		WriteLog "ossec-agent installation path exists - $installation_path"
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
        Write-Output "`r`nStarting service."
        Start-Service $srvName
        $srvStat = Get-Service $srvName
        Write-Output "Ossec-agent is $($srvStat.status)"
        WriteLog "Ossec-agent is $($srvStat.status)"
		
		WriteLog "Waiting for 60s....for service to fully start"
        Write-Output "`r`nWaiting for 60s....for service to fully start"

        Start-Sleep -s 10
		WriteLog "50s to go...."
        Write-Output "`r`n50s to go...."
		Start-Sleep -s 10
		WriteLog "40s to go...."
        Write-Output "`r`n40s to go...."
		Start-Sleep -s 10
		WriteLog "30s to go...."
        Write-Output "`r`n30s to go...."
		Start-Sleep -s 10
		WriteLog "20s to go...."
        Write-Output "`r`n20s to go...."
		Start-Sleep -s 10
		WriteLog "10s to go...."
        Write-Output "`r`n10s to go...."
		Start-Sleep -s 10

        WriteLog "Restarting ossec-agent service."
        Write-Output "`r`nRestarting ossec-agent service."
        Restart-Service $srvName
        $srvStat = Get-Service $srvName
        Write-Output "Ossec-agent is $($srvStat.status)"
        WriteLog "Ossec-agent is $($srvStat.status)"
        Start-Sleep -s 10

        WriteLog "Completed automated installation"
		Write-Output "`r`nCompleted automated installation`r`n"
       
        #Server connected or not and Hardening command executed or not Verification
        Write-Output "********************************************************"
        Write-Output "Verifying installation"
        Write-Output "********************************************************"
        WriteLog "**********Verifying installation**********"
        verify_installation
        
        Write-Output "****************************************************************************************************"
		Write-Output "** You can execute reports after 5 minutes (required for complete logs to be collected at Khika)"
		Write-Output "****************************************************************************************************"
		}else
		{
			Write-Output "Ossec-agent installation path doesn't exist. Please re-install the ossec-agent"
			WriteLog "Ossec-agent installation path doesn't exist. Please re-install the ossec-agent"
		}
}
