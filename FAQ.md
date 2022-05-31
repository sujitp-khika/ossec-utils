# General
> How do I open powershell as Administrator?

A: Press Windows key, type powershell. You will see multiple options for opening Windows Powershell. Select one that says 'Run as Administrator'

> I do not have Administrator access to the device. Can I still install the agent?

A: No, for Agent to collect all required configurations, it must be installed as Administrator user. You can reach out to respective IT Admin team for getting the agent installed.

> Where do I install the Agent? My work machine/laptop or some other server?

A: The agent needs to be installed on the device which needs to be audited. If you wish to get your laptop or work machine audited, you can install agent on the same. Typically you would want to audit a server that has audit requirements - so choose installation target according to auditing needs.

> What kind of data does the agent collect? Is there any risk of configuration change?

A: The OSSEC agent only runs in read-only mode for all operating system configurations and service level configurations required strictly for auditing needs. There is no change made to any operating system settings or configurations by this agent. You can rest assured that none of your sensitive data or credentials or personal information will be shared outside of the device. If you are still in doubt, feel free to contact us at info@khika.com

> How do I uninstall the agent?

A: Please refer [this](https://github.com/khikatech/ossec-utils/wiki/How-it-works#uninstallation) section

> Is there is auto-remediation option available?

A: No, as of now we do not have any automated remediation feature built in this SaaS offering. Please reach out to us if you have specific needs in this regard and we can assist in getting your hardening posture score to increased compliance level

> Can I see or customize which policies does the report run against?

A: Yes, from the SaaS portal, you have an option to explore or browse default policies / rules. You can also deselect the ones you feel are not applicable in your environment - via Customize Policy option.

# Support
> I have a question that is not answered anywhere on this wiki. How can I get help?

A: If you are unable to find suitable answer to your question or issue, please contact us at info@khika.com or support@khika.com. Kindly state your question clearly in the email body. Attaching relevant agent installation logs or specific screenshots or error messages if any, will help us serve you quickly.

# Business
> I have special requirements for my business needs. How can you help?

A: In case of specific requirements related to product usage or any customizations, feel free to reach out to us at info@khika.com

> How will I get billed?

A: The offering has 1 month free trial (starting from day of Activating the subscription from SaaS portal). Post this 1 month, you will be billed as per the monthly rate shown at the time of purchase in Azure marketplace or AppSource. Microsoft handles this billing process for Khika and you will typically be charged against your billing details saved in your Azure account.

> How do I cancel my subscription?

A: You can cancel at any time by going to the Azure account (in case of marketplace purchase) SaaS subscriptions page or (in case of purchase from AppSource) Admin center to cancel an active subscription as described [here](https://docs.microsoft.com/en-us/microsoft-365/commerce/manage-saas-apps?view=o365-worldwide). We will be obliged if you can let us know any particular reason of cancellation prior to cancelling it - so that we can find ways to solve those problems and serve you better. Your feedback is very important for us. 
