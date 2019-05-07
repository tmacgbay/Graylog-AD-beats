@rem ----[ This code block detects if the script is being running with admin PRIVILEGES If it isn't it pauses and then quits]-------
echo OFF
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
	echo ####### ADMINISTRATOR PRIVILEGES DETECTED #########
	echo This script installs the Graylog Sidecar log forwarder going to [YOUR GRAYLOG SERVER NAME]
	echo TAGS: windows
   	echo Press ANY KEY to continue or click X to CANCEL
   	echo ##########################################################
	PAUSE
	echo - Graylog Sidecar SERVICE STOP for install or upgrade...
	"C:\Program Files\graylog\sidecar\graylog-sidecar.exe" -service stop
	echo - Graylog Sidecar INSTALL
 	\\[UNC_PATH_TO_INSTALLER]\graylog_sidecar_installer.exe /S -SERVERURL=http://192.168.900.900:9000/api/ -TAGS="windows" 
	echo - Graylog YAML - Keep Origional...
	copy "C:\Program Files\graylog\sidecar\sidecar.yml" "C:\Program Files\graylog\sidecar\sidecar.yml-orig"
	echo - Graylog YAML - Copy Defualt Yaml to local...
	copy \\[UNC_PATH_TO_INSTALLER]\windows-graylog-sidecar.yml "C:\Program Files\graylog\sidecar\sidecar.yml"
	echo - Graylog Sidecar App Installed and configured
	echo - Graylog Sidecar SERVICE Installing...
	"C:\Program Files\graylog\sidecar\graylog-sidecar.exe" -service install 
	echo - Graylog Sidecar SERVICE Done
	echo - Graylog Sidecar SERVICE starting...
	"C:\Program Files\graylog\sidecar\graylog-sidecar.exe" -service start
	echo - Graylog Sidecar Installation Complete
	PAUSE
) ELSE (
   echo ######## ########  ########   #######  ########  
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ######   ########  ########  ##     ## ########  
   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
   echo ######## ##     ## ##     ##  #######  ##     ## 
   echo.
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as administrator to work properly!  
   echo Right click on the shortcut and select "Run As Administrator".
   echo ##########################################################
   echo.
   PAUSE
   EXIT /B 1
)
@echo ON
pause


