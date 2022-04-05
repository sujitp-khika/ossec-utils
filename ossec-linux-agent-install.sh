#!/bin/bash
# Copyright 2022 KHIKA Technologies Private Limited. All rights reserved.
# This script is written for automation of ossec-agent installation for CentOS & Ubuntu
# Official ossec site link for downloading source code and other documentation related information is available through the link https://www.ossec.net/download-ossec/
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
		logger -s "Starting automated installation"
                logger -s "Note: Do not press any key - this is automated installation"
		echo "wget installation started"
                sudo yum install wget -y
		echo "wget installation completed"
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
		logger -s "Starting automated installation"
		logger -s "Note: Do not press any key - this is automated installation"
		echo "wget installation started"
                sudo apt-get install wget -y
                echo "wget installation completed"
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
                sudo /var/ossec/bin/ossec-control restart
		logger -s "(Note: Please ignore any Error saying 'ERROR: Duplicated directory given /bin or /etc')"
		logger -s "Completed automated installation"
else
        echo "OS Name=$os_name"
        echo "If OS Name is other than CENTOS/UBUNTU Please follow the manual installation step guide to download and install from https://www.ossec.net/download-ossec/"
        echo "For HELP please contact us on https://khika.com/"
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

