# GraylogMarket - Active Directory Monitoring and Alerting - Beats      
Graylog Content Pack

 - Winlogbeat Input, Lookup Tables, Pipeline rules, Sidecar Configuration, Streams, Alert Conditions and Notifications, Dashboard 
 - monitors and alerts on User/Group/OU changes (rules and framework)
 - Additional framework for monitoring Windows Warnings and Errors
 - Alerting on Exchange 2013 certificate expiry
 
 -- Tested wint Graylog 3 on Ubuntu 19 and Active Directory 2012 R2.
 
This content pack was built as a method to make sure IT was aware of changes happinging in Active Directory and as a basic framework for monitoring some Windows Security Issues.  It is incomplete for security monitoring as it relies only on what is kicked out in Windows standard logs... so don't rely on it for that... feel free to upgrade it though.

NOTE:   There are installation caveats that will cause you problems if you don't look into them.  

1) Configuration Parameter "Authentication events minus DCs" - modify the last two items [DC-Name].  You can use wildcards in the name like DCSRV*.  We have multiple domains so I had two listed in the query (NOTE cmg_requestingName is a pipeline insertion). The to-be-modified field is currently as follows (winlogbeat_event_id:4625 OR winlogbeat_event_id:4771 OR winlogbeat_event_id:4820) AND NOT cmg_requestingName:[DC-NAME] AND NOT cmg_requestingName:[DC-NAME]
 
2) You need to set up external distribution groups.  We have set up distribution groups on our e-mail server for different levels of alerts.  P1 alerts go to all internal and external IT e-mail and their pagers, p2 alerts go only to internal e-mail and P3 is not alerted on but is separated for reporting purposes.

3) Download or create the following files to /etc/graylog.  The are used for more detail in alert e-mail.
	- admin_groups.csv
	- login_failure_code.csv
	- login_types.csv
	
4) In System->Sidecars->Configuration - edit both WinlogsDefault and Winlogs-DC to make sure their "Collector" is set to "winlogbeat on Windows"  CANCEL setting it to the default template... unless you want to.  While you are there, click on "Variables" and edit ${user.BeatsInput} and change the servername from cmg-splunk to the FQDN or IP of your Graylog server.  Be sure to set the correct port if you moved it (default is :5044)

5) OF NOTE:  I created a separate INDEX for the winShortLife stream so I could toss the junk out early.  It is a catch all for information and the idea is to pull out things you are interested and let the rest fade away at a more reasonable time.   I also didn't make it TOO short in case there was a larger isssue I needed to track down.

6) To track things properly you need to set AD policy on for at least all DCs - pereferably all servers... and if you are frought on security, all workstations as well.  You can download the Advanced-Audit-Policy-Configuration.csv I thrown together for a base setting for having usditing logs in your "Default Domain Controlers Policy" or in your all servers policy...  It's a basic framework - adjust as needed.  To import, edit the policy of your choice and ComputerConfiguration->WindowsSettings->SecuritySettings->AdvancedAuditPolicyConfiguration and right click on Audit Policies 
