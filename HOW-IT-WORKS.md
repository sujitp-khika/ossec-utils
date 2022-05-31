# Overview
* Khika server hardening audit reports needs OSSEC agent to be installed on device to be audited
* The agent installation steps are given on SaaS portal based on type of operating system of device. It also has a secret key embedded which is unique to customer and should never be shared with anyone.
* Once the OSSEC agent is installed on the device, this agent captures various parameters to be audited and sends to Khika server (Azure Cloud)
* On the server side the logs sent by OSSEC agent are parsed and stored for later report generation
* When the report is run by end user, these logs are retrieved from storage and then analyzed in conjunction with hardening policies and an audit report is generated
* The generated report is presented to end user in the form of CSV which can be downloaded or emailed from SaaS portal

# Agent Installation
* OSSEC Agent is a program from Atomicorp and available publicly
* This agent is required to be installed as root/administrator so that all critical configurations can be read and audited. Without root or adminstrator access, this feature will not work
* Khika Team has created a wrapper installer script to make complete installation process easier and painless for end user
* If you wish to understand how this wrapper script works, it is available in this repo - Linux [here](https://github.com/khikatech/ossec-utils/blob/main/ossec-linux-agent-install.sh) and Windows [here](https://github.com/khikatech/ossec-utils/blob/main/ossec-win-agent-install.ps1)

# Report Generation
* Once the agent is successfully installed, end user can typically be able to run report after 3-5 minutes
* This delay is needed for server side to fully collect all required logs from agent and store it after parsing
* In case you do not see a report available in the list of reports, try after 5 minutes and if it still does not work, please reach out to us

# Uninstallation
* In case end user wants to remove the installed agents for any reason (e.g. re-install or unsubscribe from the service), it can be done using uninstall scripts given in this repo. These scripts can be run using root/Administrator user. Linux uninstall script is [here](https://github.com/khikatech/ossec-utils/blob/main/ossec-linux-agent-uninstall.sh). You can download this script and run from linux shell. For Windows, you can use standard Add/Remove programs utility to remove OSSEC agent.
