#!/bin/bash
# Copyright 2022 KHIKA Technologies Private Limited. All rights reserved.
# This script is written for automation of ossec-agent uninstallation for CentOS & Ubuntu
os_name=`grep "PRETTY_NAME" /etc/os-release |  cut -f2 -d"="`
log_file=$(pwd)/ossec-linux-agent-uninstallation.log
user=`whoami`

if [ "$user" != "root" ]; then
   echo "You must be root user"
   exit
fi
exec >$log_file
if [[ "$os_name" == *"CentOS Linux"* ]] || [[ "$os_name" == *"Ubuntu"* ]]; then
        echo "OS Name="$os_name
	    echo "############################################################################"
        logger -s "***************************************************************"
		logger -s "** Starting automated uninstallation"
        logger -s "** Note: Do not press any key - this is automated uninstallation"
		logger -s "** Note: uninstallation process may take 1-2 minutes to complete"
		logger -s "****************************************************************"$'\r\n\n'
        echo "Starting automated uninstallation"
		if [ -d "/var/ossec" ]; then
            echo "Directory /var/ossec exists" 
            logger -s "Directory /var/ossec exists"
            echo "Stopping ossec-agent"
            logger -s  "Stopping ossec-agent"
	        sudo /var/ossec/bin/ossec-control stop
	        echo "#############################################################################"
        else
            echo "Error: Directory /var/ossec does not exist"
            logger -s "Error: Directory /var/ossec does not exist"
            exit
        fi
        if [[ "$os_name" == *"CentOS Linux"* ]]; then
            logger -s "ossec-agent uninstallation started"
            echo "ossec-agent uninstallation started"
            sudo yum remove ossec-hids-agent -y
            sleep 30
            sudo rm -f /etc/ossec-init.conf
            logger -s "Removing ossec directory"
		    echo "##################################################################"
            echo "Removing ossec directory"
            sudo rm -rf /var/ossec
            echo "#################################################################"
            rpm_package=`rpm -qa | grep 'atomic'`
            echo "Removing atomic rpm package: $rpm_package"
            rpm -e $rpm_package
            ossec_package=`rpm -qa | grep 'ossec'`
            echo "Removing ossec package: $ossec_package"
		    rpm -e $ossec_package
            echo "################################################################"
		    echo "ossec-agent uninstallation complted"
            logger -s "ossec-agent uninstallation complted"
        elif [[ "$os_name" == *"Ubuntu"* ]]; then
            logger -s "ossec-agent uninstallation started"        
            echo "ossec-agent uninstallation started"
            sudo apt-get remove ossec-hids-agent --purge -y
            sleep 30
            sudo rm -f /etc/ossec-init.conf
		    logger -s "Removing ossec directory"
		    echo "##################################################################"
            echo "Removing ossec directory"
            sudo rm -rf /var/ossec
		    echo "ossec-agent uninstallation complted"
            logger -s "ossec-agent uninstallation complted"
        fi
		logger -s "Completed automated uninstallation"
        echo "Completed automated uninstallation"
		
else
        echo "OS Name=$os_name"
        echo "If OS Name is other than CentOS/Ubuntu Please follow the manual uninstallation step guide from https://www.ossec.net/download-ossec/"
        echo "For assitance, please contact us on support@khika.com"
        exit
fi
