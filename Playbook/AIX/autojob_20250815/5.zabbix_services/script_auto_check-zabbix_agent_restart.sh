# Script for auto restart zabbix agent monitoring on AIX server
# Author : Mr.Thanawan Sukanta
# 24 Jun 2025
#
LOG=/bigc/log/zabbix_workload.log
LOGerr=/bigc/log/zabbix_workload.err`date +%Y%m%d`

#ps aux | head |grep zabbix
ps aux | head |grep oraclecdbprod
        if [ $? -eq 0 ]
        then
echo "\n---------------------- EIS Command Center ----------------------\n" >$LOG
                echo "Automatic detection and operation by EIS Command Center\n" >>$LOG
		echo "Automatic restart zabbix agent\n" >>$LOG
		/bigc/script/script_zabbix_agent_restart.sh
                if [[ $? -eq 0 ]]
                then
		sleep 5 
		echo "Show current zabbix agent process: \n" >>$LOG
                ps -ef|grep zabbix_agentd >>$LOG
                echo "\nRecommended Action: No response action is required." >>$LOG
echo "\n---------------------- By EIS Command Center ----------------------\n" >>$LOG

/usr/bin/mail -s "EIS Command Center (Unix-Linux Team): Found Zabbix aix agent process high workload and restarted on host '`hostname`' " command_center_alert@bigc.co.th,mis_enterprise_unix_and_linux_technology@bigc.co.th,nsoc@bigc.co.th,suthanawan@bigc.co.th <$LOG

                else
echo "\n---------------------- EIS Command Center ----------------------\n" >$LOGerr
                echo "Automatic detection and operation by EIS Command Center\n" >>$LOGerr
		echo "Automatic restart zabbix agent\n" >>$LOGerr
		sleep 5 
		echo "Show current zabbix agent process: \n" >>$LOGerr
                ps -ef|grep zabbix_agentd >>$LOGerr
echo "\nRecommended Action: Please call to EIS Unix-Linux Admin Team for review" >>$LOGerr
echo "\n---------------------- By EIS Command Center ----------------------\n" >>$LOGerr

mail -s "EIS Command Center (Unix-Linux Team): Found Zabbix aix agent process high workload and restarted on host '`hostname`' " command_center_alert@bigc.co.th,mis_enterprise_unix_and_linux_technology@bigc.co.th,nsoc@bigc.co.th,suthanawan@bigc.co.th <$LOGerr
                fi
        fi

