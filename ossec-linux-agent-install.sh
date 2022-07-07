#!/bin/bash
# Copyright 2022 KHIKA Technologies Private Limited. All rights reserved.
# This script is written for automation of ossec-agent installation for CentOS & Ubuntu
# Official ossec site link for downloading source code and other documentation related information is available through the link https://www.ossec.net/download-ossec/

restart_agent_verify(){
echo "Hardening audit logs not found"
logger -s "Hardening audit logs not found"
echo "Trying to connect server after restart"
logger -s "Trying to connect server after restart"
echo "Restarting ossec-agent service."
logger -s "Restarting ossec-agent service."
sudo /var/ossec/bin/ossec-control restart    
echo "Waiting for 30s"
logger -s "Waiting for 30s"
sleep 30

osseclog="/var/ossec/logs/ossec.log"
conectedServer_Data=`cat $osseclog | grep "Connected to server"`
hardeningExecuted_Data=`cat $osseclog | grep "Linux_cis_benchmark.sh"`
echo "conectedServer_Data=$conectedServer_Data"
echo "hardeningExecuted_Data=$hardeningExecuted_Data"

conectedServer_Date=`cat $osseclog | grep "Connected to server" | tail -1 | awk '{print $1,$2}'`
hardeningExecuted_Date=`cat $osseclog | grep "Linux_cis_benchmark.sh" | tail -1 | awk '{print $1,$2}'`
conectedServer_epoch=$(date -d "${conectedServer_Date}" +"%s")
hardeningExecuted_epoch=$(date -d "${hardeningExecuted_Date}" +"%s")
currentDateTime=`date`
currentDateTime_epoch=$(date -d "${currentDateTime}" +"%s")
refrence_DateTime=$(expr $currentDateTime_epoch - 300)

if [[ "$conectedServer_epoch" -eq " " ]]; then
        echo "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
        logger -s "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
        exit
fi

if [[ "$refrence_DateTime" -lt "$conectedServer_epoch" ]]; then
        echo "Agent is connected to Server"
        logger -s "Agent is connected to Server"
else
        echo "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
        logger -s "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
        exit
fi
  
# Below code block verifies the hardening command is executed or not.
if [[ !("$hardeningExecuted_epoch" -eq " ") ]]; then
	if [[ "$refrence_DateTime" -lt "$hardeningExecuted_epoch" ]]; then
		echo "Hardening audit logs found"
        logger -s "Hardening audit logs found"
	else
        echo "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
		logger -s "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
		exit 
    fi
else
	echo "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
    logger -s "Hardening audit logs not found. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
	exit
fi
}

verify_installation(){
osseclog="/var/ossec/logs/ossec.log"
conectedServer_Data=`cat $osseclog | grep "Connected to server"`
hardeningExecuted_Data=`cat $osseclog | grep "Linux_cis_benchmark.sh"`
echo "conectedServer_Data=$conectedServer_Data"
echo "hardeningExecuted_Data=$hardeningExecuted_Data"

conectedServer_Date=`cat $osseclog | grep "Connected to server" | tail -1 | awk '{print $1,$2}'`
hardeningExecuted_Date=`cat $osseclog | grep "Linux_cis_benchmark.sh" | tail -1 | awk '{print $1,$2}'`
conectedServer_epoch=$(date -d "${conectedServer_Date}" +"%s")
hardeningExecuted_epoch=$(date -d "${hardeningExecuted_Date}" +"%s")
currentDateTime=`date`
currentDateTime_epoch=$(date -d "${currentDateTime}" +"%s")
refrence_DateTime=$(expr $currentDateTime_epoch - 300)

if [[ "$conectedServer_epoch" -eq " " ]]; then
	echo "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
    logger -s "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
    exit
fi

if [[ "$refrence_DateTime" -lt "$conectedServer_epoch" ]]; then
	echo "Agent is connected to Server"
    logger -s "Agent is connected to Server"
else
	echo "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
    logger -s "Agent Failed to connect Server. Please contact us for support on support@khika.com with ossec-linux-agent-installation.log file"
    exit
fi

if [[ !("$hardeningExecuted_epoch" -eq " ") ]]; then
	if [[ "$refrence_DateTime" -lt "$hardeningExecuted_epoch" ]]; then
		echo "Hardening audit logs found"
        logger -s "Hardening audit logs found"
	else
        restart_agent_verify
    fi
else
    restart_agent_verify
fi       
}

main()
{
os_name=`grep "PRETTY_NAME" /etc/os-release |  cut -f2 -d"="`
log_file=$(pwd)/ossec-linux-agent-installation.log
export NON_INT=1
export INPUTTEXT="yes"
user=`whoami`

if [ "$user" != "root" ]; then
   echo "You must be root user"
   exit
fi
exec >$log_file
if [[ "$os_name" == *"CentOS Linux"* ]] || [[ "$os_name" == *"Ubuntu"* ]]; then
        echo "OS Name="$os_name
		echo "############################################################################"
        if [[ "$os_name" == *"CentOS Linux"* ]]; then
		logger -s "***************************************************************"
		logger -s "** Starting automated installation"
        logger -s "** Note: Do not press any key - this is automated installation"
		logger -s "** Note: Installation process may take 3-5 minutes to complete"
		logger -s "****************************************************************"$'\r\n\n'
		echo "Starting automated installation"
		echo "wget installation started"
                sudo yum install wget -y
		echo "wget installation completed"
		echo "############################################################################"
		ossec_install="$(rpm -qa ossec-hids-agent)"
		 if [[ -z "$ossec_install" ]]; then
		 		echo "OSSEC-HIDS agent automated installation process will start now."
				logger -s "OSSEC-HIDS agent automated installation process will start now."
        else
                echo "OSSEC-HIDS agent is already installed. Please uninstall the OSSEC-HIDS agent for automated installation process to continue"
				logger -s "OSSEC-HIDS agent is already installed. Please uninstall the OSSEC-HIDS agent for automated installation process to continue"
				exit
        fi
		echo "############################################################################"
		echo "ossec-agent packages download started"
                wget -q -O - https://updates.atomicorp.com/installers/atomic | sudo -E bash
		echo " ossec-agent packages download completed"
		echo "############################################################################"
		echo "ossec-agent installation started"
                sudo yum install ossec-hids-agent -y
		echo "ossec-agent installation complted"
		echo "############################################################################"
                sed -E -i "s/[0-9]{1,3}(\.[0-9]{1,3}){3}/$server_ip/g" /var/ossec/etc/ossec.conf
		echo "server IP updated:" $server_ip
                touch /var/ossec/queue/rids/sender
		yes | sudo /var/ossec/bin/manage_agent -i "$device_key"
		echo "Device Added with key:" $device_key

        elif [[ "$os_name" == *"Ubuntu"* ]]; then
		logger -s "***************************************************************"
		logger -s "** Starting automated installation"
		logger -s "** Note: Do not press any key - this is automated installation"
		logger -s "** Note: Installation process may take 3-5 minutes to complete"
		logger -s "** Please ignore WARNING: apt does not have a stable CLI interface. Use with caution in scripts."
        logger -s "****************************************************************"$'\r\n\n'
		echo "Starting automated installation"
		echo "wget installation started"
        sudo apt-get install wget -y
        echo "wget installation completed"
		echo "############################################################################"
		ossec_installed=`apt list -a ossec-hids-agent| awk '{print $4}'`
        if [[ "$ossec_installed" == *"installed"* ]]; then
                echo "OSSEC-HIDS agent is already installed. Please uninstall the OSSEC-HIDS agent for automated installation process to continue"
				logger -s "OSSEC-HIDS agent is already installed. Please uninstall the OSSEC-HIDS agent for automated installation process to continue"
				exit
        else
                echo "OSSEC-HIDS agent automated installation process will start now."
				logger -s "OSSEC-HIDS agent automated installation process will start now."
        fi
		echo "############################################################################"
		echo "ossec-agent packages download started"
		wget -q -O - https://updates.atomicorp.com/installers/atomic | sudo -E bash
        echo "ossec-agent packages download completed"
		echo "############################################################################"
		echo "Ubuntu update started"
		sudo apt-get update
		echo "Ubuntu update completed"
		echo "############################################################################"
        echo "ossec-agent installation started"
		sudo apt-get install ossec-hids-agent -y
		echo "ossec-agent installation complted"
		echo "############################################################################"
        sed -E -i "s/[0-9]{1,3}(\.[0-9]{1,3}){3}/$server_ip/g" /var/ossec/etc/ossec.conf
		echo "server IP updated:" $server_ip
        touch /var/ossec/queue/rids/sender
		yes | sudo /var/ossec/bin/manage_agents -i "$device_key"
		echo "Device Added with key:" $device_key
        fi
                sed -i 's/logcollector.remote_commands=0/logcollector.remote_commands=1/g' /var/ossec/etc/internal_options.conf
                sed -i 's/remoted.verify_msg_id=1/remoted.verify_msg_id=0/g' /var/ossec/etc/internal_options.conf
                sudo /var/ossec/bin/ossec-control start
				logger -s "Waiting for 60s....for service to fully start"
				echo "Waiting for 60s....for service to fully start"
				sleep 10
				logger -s "50s to go...."
				echo -n "50s to go...."
				sleep 10
				logger -s "40s to go...."
				echo -n "40s to go...."
				sleep 10
				logger -s "30s to go...."
				echo -n "30s to go...."
				sleep 10
				logger -s "20s to go...."
				echo -n "20s to go...."
				sleep 10
				logger -s "10s to go...."
				echo -n "20s to go...."
				sleep 10
				logger -s "Completed 60s wait"
				echo "Completed 60s wait"
				echo "Restating ossec-agent"
				logger -s "Restating ossec-agent"
                sudo /var/ossec/bin/ossec-control restart
				sleep 15
		echo "(Note: Please ignore any message saying 'Duplicated directory given /bin or /etc')"
		echo "Completed automated installation"
		logger -s "(Note: Please ignore any message saying 'Duplicated directory given /bin or /etc')"
		logger -s "Completed automated installation"$'\r\n\n\n'

		#Server connected or not and Hardening command executed or not Verification
        logger -s "********************************************************"
        logger -s "Verifying installation"
        logger -s "********************************************************"
        echo "**********Verifying installation**********"
        verify_installation
		
		logger -s "******************************************************************************************"
		logger -s "** You can execute reports after 5 minutes (required for logs to be collected at Khika)"
		logger -s "******************************************************************************************"
		
else
        echo "OS Name=$os_name"
        echo "If OS Name is other than CentOS/Ubuntu Please follow the manual installation step guide to download and install from https://www.ossec.net/download-ossec/"
        echo "For assitance, please contact us on support@khika.com"
        exit
fi
}
helpFunction()
{
   echo ""
   echo "Usage: $0 --server_ip 'VALUE'  --device_key 'KEY'"
   echo -e "\t--server_ip server ip"
   echo -e "\t--device_key device key"
   exit 1 # Exit script after printing help
}
while getopts ":-:" opt
do
   case "$OPTARG" in
      server_ip ) server_ip="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 )) ;;
      device_key ) device_key="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 )) ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done
# Print helpFunction in case parameters are empty
if [ -z "$server_ip" ] || [ -z "$device_key" ]
then
	echo "Some or all of the parameters are empty";
	helpFunction
fi
main