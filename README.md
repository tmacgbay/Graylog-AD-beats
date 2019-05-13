# GraylogMarket - Active Directory Monitoring and Alerting - Beats      
---read ALL of this before taking any action.

Graylog Content Pack - AD-Monitoring-Alerts-Beats.json

 - Winlogbeat Input, Lookup Tables, Pipeline rules, Sidecar Configuration, Streams, Alert Conditions and Notifications, Dashboard 
 - monitors and alerts on User/Group/OU changes (rules and framework)
 - Additional framework for monitoring Windows Warnings and Errors
 - Alerting on Exchange 2013 certificate expiry
 
 -- Tested with 
 * Graylog 				3.0.1 (Space Moose)
	- MongoDB 			4.0.9
	- Elasticsearch: 	6.7.1
 * Ubuntu 19 			19.04
 * Active Directory 	2012 R2.
 
This content pack was built as a method to make sure IT was aware of changes happinging in Active Directory and as a basic framework for monitoring some Windows Security Issues.  It is incomplete for security monitoring as it relies only on what is kicked out in Windows logs... so don't rely on it for that... feel free to upgrade it though.

NOTE:   There are installation caveats that will cause you problems if you don't look into them. Your system may need tuning not listed here after the install.

1) Configuration Parameter "Authentication events minus DCs" - modify the last two items [DC-Name].  You can use wildcards in the name like DCSRV*.  We have multiple domains so I had two listed in the query (NOTE cmg_requestingName is a pipeline insertion). The to-be-modified field is currently as follows (winlogbeat_event_id:4625 OR winlogbeat_event_id:4771 OR winlogbeat_event_id:4820) AND NOT cmg_requestingName:[DC-NAME] AND NOT cmg_requestingName:[DC-NAME]
 
2) You need to set up external distribution groups.  We have set up distribution groups on our e-mail server for different levels of alerts.  P1 alerts go to all internal and external IT e-mail and their pagers, p2 alerts go only to internal e-mail and P3 is not alerted on but is separated for reporting purposes.

3) Download or create the following files to /etc/graylog.  The are used for more detail in alert e-mail.
	- admin_groups.csv
	- login_failure_code.csv
	- login_types.csv
	
4) In System->Sidecars->Configuration - edit both WinlogsDefault and Winlogs-DC to make sure their "Collector" is set to "winlogbeat on Windows"  CANCEL setting it to the default template... unless you want to.  While you are there, click on "Variables" and edit ${user.BeatsInput} and change the servername from cmg-splunk to the FQDN or IP of your Graylog server.  Be sure to set the correct port if you moved it (default is :5044)

5) OF NOTE:  I created a separate INDEX for the winShortLife stream so I could toss the junk out early.  It is a catch all for information and the idea is to pull out things you are interested and let the rest fade away at a more reasonable time.   I also didn't make it TOO short in case there was a larger isssue I needed to track down.

6) To track things properly you need to set AD policy on for at least all DCs - pereferably all servers... and if you are frought on security, all workstations as well.  You can download the Advanced-Audit-Policy-Configuration.csv I thrown together for a base setting for having usditing logs in your "Default Domain Controlers Policy" or in your all servers policy...  It's a basic framework - adjust as needed.  To import, edit the policy of your choice and ComputerConfiguration->WindowsSettings->SecuritySettings->AdvancedAuditPolicyConfiguration and right click on Audit Policies.   For more visual details you can look at [https://www.lepide.com/how-to/track-changes-in-active-directory.html]  If you want to read more on Audit Policy: [https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/audit-policy-recommendations] and [https://www.ultimatewindowssecurity.com/securitylog/book/page.aspx?spid=chapter1]

7)  I have also included the sidecar .bat installer we created as well as the default .yml that we copy in to the client before starting the Sidecar - this way the sidecars first start will already knwo about the Graylog server.  Make sure you go into the .bat file and change out things like [UNC_PATH_TO_INSTALLER] or the server API token.   I am not going into detail here because you should know the details of what you are doing to your server and not just plug things in that some dude on the internet said you should and because this is not a boost, not a HOWTO.  The sidecar installer named in the .bat shoud match the path and name to the installer in your environment.

Some notes on how this Content Pack is set up so you understand what you are getting.
1) Beats Sidecar installers with .yml file set up for default logs and pointing Sidecar service to the correct Graylog server to get future configuration from.

2) winBeats-Input created with default winbeats port 5044

3) Messages are received into two streams - winShortLifeStream for all "information" level logs and WinWarnError for all "Warning" and "Error" whihc allows me to set a seperate index on "information" level logs and toss them after 5 days.  This short life index is NOT included in the Content Pack, you will have to adjust for it yourself.  See installation note #5 above.

4) The primary pipeline is winSECAlert which examines all logs coming in (both winShortLifeStream and WinWarnError) the initial stage checks for relevence and allows for dropping messages via rule, though you should consider dropping rules at the client rather than in the pipeline for efficiancy.  (More on beats client commands can be found here: https://www.elastic.co/guide/en/beats/winlogbeat/5.4/configuration-winlogbeat-options.html)  subsequent stages work on the event ID to find events to alert on.  The stages are generally arranged by likleyhood of event and set to pass through to the next stage if the event wasn't found.   I didn't want to build an pipeline/condition/notification for each event ID since it would be a LOT of duplication of effort so Alerts are generic (explained below) and it is the pipeline that build the key information.  So when an event to be alerted on is found, two fields are created for the e-mail alert - cmg_subject and cmg_body.  In some cases the event explains sufficiently so cmg_body isn't built. the rule then shifts the message to a alert priority stream P1-Alert, P2-Alert, P3-Alert each of which has defined notification (as explained below)  

5) There is a separate pipeline (P1-P2: ALERT MARKER) that watches for anything being shifted to the p1-alert or p2-alert streams and adds an ALERT field in to set a condition of notification against
	



