#########################################################################################
# Description   :       For check print queue and auto restart.
# Create Date   :       26 may 2007
# Last Update   :       26 Feb 2012 By Sitthisak
# Last Update   :       9 Jun 2025 By Sitthisak,Thanawan
#########################################################################################

#sith lpstat | grep DOWN | grep dvgr | awk '{print $1}'| while read a
#for a in  lpbg5 lpbg6

cd /bigc/script
/usr/bin/lssrc -g spooler |grep inoperative
if [ $? -eq 0 ]
then
	echo "\n---------------------- EIS Command Center ----------------------\n" > chk_spooler.out
	echo "Automatic detection and operation by EIS Command Center\n" >> chk_spooler.out
	echo "Auto start service group spooler" >> chk_spooler.out
	date >> chk_spooler.out
	echo "Show list service group of spooler : " >> chk_spooler.out
	/usr/bin/lssrc -g spooler >> chk_spooler.out
	/usr/bin/startsrc -g spooler
	date >> chk_spooler.out
	/usr/bin/lssrc -g spooler >> chk_spooler.out
	mail -s "EIS Command Center (Unix-Linux Team): Warning,Host:`hostname` found AIX service - spooler restarted at `date`" suthanawan@bigc.co.th < chk_spooler.out
	sleep 5
	date >> chk_spooler.out
	echo "Show list service group of spooler : " >> chk_spooler.out
	/usr/bin/lssrc -g spooler >> chk_spooler.out
	echo "\nRecommended Action: If status: running, No response action is required." >> chk_spooler.out
	echo "\nRecommended Action: If status: inoperative, Please call to EIS Unix-Linux Admin Team for review" >> chk_spooler.out
	mail -s "EIS Command Center (Unix-Linux Team): Warning,Host:`hostname` found AIX service - spooler restarted at `date`" suthanawan@bigc.co.th < chk_spooler.out
	
fi

echo "\n---------------------- EIS Command Center ----------------------\n" > /bigc/log/queue_check.tmp
echo "Automatic detection and operation by EIS Command Center\n" >> /bigc/log/queue_check.tmp 
echo "Auto disable and enable print queue\n" >> /bigc/log/queue_check.tmp 
date >> /bigc/log/queue_check.tmp
lpstat -a  >> /bigc/log/queue_check.tmp

for a in lpbg5 lpbg6 lpbg1
do
 lpstat -p${a} | grep DOWN
 if [[ $? -eq 0 ]]
 then
        echo "Found queue ${a} was down then " >/bigc/log/queue_check_`date +%d%m%y`.down
        lpstat -W -p$a >>/bigc/log/queue_check_`date +%d%m%y`.down
        disable $a
        enable $a
sleep 15 
echo "\n=============================== POST AUTO TASKS STATUS ===============================\n" >> /bigc/log/queue_check.tmp
date >> /bigc/log/queue_check.tmp
lpstat -a  >> /bigc/log/queue_check.tmp
echo "\nRecommended Action: If status: READY/RUNNING, No response action is required." >> /bigc/log/queue_check.tmp 
echo "\nRecommended Action: If status: DOWN, Please call to EIS Unix-Linux Admin Team for review" >> /bigc/log/queue_check.tmp

	echo "\n---------------------- By EIS Command Center ----------------------\n" >> /bigc/log/queue_check_`date +%d%m%y`.down
        echo "First action by auto disable and enable on OFI">>/bigc/log/queue_check_`date +%d%m%y`.down
        mail -s "EIS Command Center (Unix-Linux Team): Found print queue name ${a} was DOWN and then auto enable a part of OFI server (`hostname`) at `date`" command_center_alert@bigc.co.th,mis_enterprise_unix_and_linux_technology@bigc.co.th,nsoc@bigc.co.th,suthanawan@bigc.co.th </bigc/log/queue_check_`date +%d%m%y`.down
	sleep 5
	mail -s "EIS Command Center (Unix-Linux Team): Re check print queue name ${a} was DOWN and then auto enable a part of OFI server (`hostname`) at `date`" command_center_alert@bigc.co.th,mis_enterprise_unix_and_linux_technology@bigc.co.th,nsoc@bigc.co.th,suthanawan@bigc.co.th < /bigc/log/queue_check.tmp
 fi
done
