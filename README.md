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

3) Download or create the following files:
-- /etc/graylog/admin_groups.csv
"nicename", "ADname"
"Administrators", "Administrators"
"Backup Operators", "Backup Operators"
"DNS Admins", "DNSAdmins"
"Domain Admins", "Domain Admins"
"Enterprise Admins", "Enterprise Admins"
"Organization Management", "Organization Management"
"Schema Admins", "Schema Admins"
 
-- /etc/graylog/login_failure_code.csv
"err_code", "explanation"
"0x6", "Bad username - kerberos"
"0x7", "New computer account(?) - kerberos"
"0x9", "Administrator should reset password - kerberos"
"0xC", "Workstation Restriction - kerberos"
"0x12", "Account Disabled, expired, locked out, logon hours restriction - kerberos"
"0x17", "The users password has expired - kerberos"
"0x18", "Bad Password - kerberos"
"0x20", "Frequently logged by computer accounts - kerberos"
"0x25", "Workstation clock too far out of sync with the DCs - kerberos"
"0xC0000064", "User name does not exist - NTLM"
"0xC000006A", "User name is correct but the password is wrong - NTLM"
"0xC0000234", "User is currently locked out - NTLM"
"0xC0000072", "Account is currently disabled - NTLM"
"0xC000006F", "User tried to logon outside his day of week or time of day restrictions - NTLM"
"0xC0000070", "Workstation restriction - NTLM"
"0xC00000193", "Account expiration - NTLM"
"0xC0000071", "Expired password - NTLM"
"0xC0000133", "Clocks between DC and other computer too far out of sync - NTLM"
"0xC0000224", "User is required to change password at next logon - NTLM"
"0xC0000225", "Evidently a bug in Windows and not a risk (per ultimateITSecurity.com) - NTLM"
"0xC000015b", "The user has not been granted the requested logon type (aka logon right) at this machine - NTLM"

-- /etc/graylog/login_types.csv
"number","type"
"2","Interactive"
"3","Network"
"4","Batch"
"5","Service"
"7","Unlock"
"8","NetworkClearText"
"9","NewCredentials"
"10","RemoteInteractive"
"11","CachedInteractive"
