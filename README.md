# GraylogMarket - Active Directory Monitoring and Alerting - Beats      
Graylog Content Pack

 - Winlogbeat Input, Lookup Tables, Pipeline rules, Sidecar Configuration, Streams, Alert Conditions and Notifications, Dashboard 
 - monitors and alerts on User/Group/OU changes (rules and framework)
 - Additional framework for monitoring Windows Warnings and Errors
 - Alerting on Exchange 2013 certificate expiry
 
This content pack was built as a method to make sure IT was aware of changes happinging in Active Directory and as a basic framework for monitoring some Windows Security Issues.  It is incomplete for security monitoring as it relies only on what is kicked out in Windows standard logs... so don't rely on it for that... feel free to upgrade it though.

NOTE:   There are installation caveats that will cause you problems if you don't look into them.  

1) Configuration Parameter "Authentication events minus DCs" - modify the last two items <DC-Name>.  You can use wildcards in the name like DCSRV*.  We have multiple dominas so I had two listed in the query (NOTE cmg_requestingName is a pipeline insertion). The to-be-modified field is currently as follows (winlogbeat_event_id:4625 OR winlogbeat_event_id:4771 OR winlogbeat_event_id:4820) AND NOT cmg_requestingName:<DC-NAME> AND NOT cmg_requestingName:<DC-NAME>
 
2) You need to set up external distribution groups.  We have set up distribution groups on our e-mail server for different levels of alerts.  P1 alerts go to all internal and external IT e-mail and their pagers, p2 alerts go only to internal e-mail and P3 is not alerted on but is separated for reporting purposes.

3) Download or create the following files to /etc/graylog
	- admin_groups.csv
	- login_failure_code.csv
	- login_types.csv
