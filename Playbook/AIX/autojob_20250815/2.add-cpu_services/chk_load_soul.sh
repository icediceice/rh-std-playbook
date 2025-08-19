
# This script is agent for monitor load average
# Author : Thanawan Sukanta 
# Date : 19 Jan 2005 
# System : AIX

# Intital Congiguration
SOUL_PATH=/usr/enterprise/souls
POLLING_CONFIG=$SOUL_PATH/conf/poll.conf
LOAD_CONFIG=$SOUL_PATH/conf/load_soul.conf
LOAD_LOG=$SOUL_PATH/load_soul.log
LOAD_LOG_AUTOJOB=$SOUL_PATH/load_soul_autojob.log
TEMP_LOG=$SOUL_PATH/load_soul_tmp.$$
TEMP_LOG2=$SOUL_PATH/load_soul2_tmp.$$
HOST=`hostname`
SOUL_NAME=load
COLLECTOR_SOULS=/usr/enterprise/relay/collector_souls.sh

# Read configuration file for polling system
while read -r MONITOR_NAME INTERVALS TIMES
do
	if [ $MONITOR_NAME = "load" ]; then
		period=$INTERVALS
		counter=$TIMES
	fi
done < $POLLING_CONFIG

# Delete old tempolary file load_soul.pid and created its
rm -rf $SOUL_PATH/load_soul_tmp.*
while read -r LOAD_NAME MAX
do
	if [ $LOAD_NAME != "LOAD_NAME" ]; then
		CURRENT=`uptime | awk '{print $10}' | cut -f 1 -d ,`
		echo $LOAD_NAME 0 $CURRENT >> $TEMP_LOG
	fi
done < $LOAD_CONFIG

# Infinite Loop
while true
do
	# Read configuration file for load soul
	while read -r LOAD_NAME MAX
	do
	if [ $LOAD_NAME != "LOAD_NAME" ]; then
		flag="false"
		# We want to use output from this command so we can't use argument >/dev/null 2>&1
		CURRENT=`uptime | awk '{print $10}' | cut -f 1 -d ,`
		# Current Used % greater than Max Used %
		if [ $CURRENT -gt $MAX ]; then
			# Counter <= 1 No need to check tempolary file
			if [ $counter -le 1 ]; then
				# Set flag for send message
				flag="true"
			# Counter > 1 Consideration tempolary file
			else
				# Read tempolary file and plus counter to another tempolary file
				while read -r NAME USED VALUE
				do
					if [ $NAME = $LOAD_NAME ]; then
						if [ $(($USED+1)) -ge $counter ]; then
							# Set flag for send message
							flag="true"
							# Reset used to zero
							echo $LOAD_NAME 0 $CURRENT >> $TEMP_LOG2
						else
							# Plus used and compare with counter
							echo $LOAD_NAME $(($USED+1)) $CURRENT >> $TEMP_LOG2
						fi
					else
						echo $NAME $USED $VALUE >> $TEMP_LOG2
					fi
				done < $TEMP_LOG
				mv $TEMP_LOG2 $TEMP_LOG
			fi
		# Current Used % lower than Max Used %
		else
			# Read tempolary file and reset counter to another tempolary file
			while read -r NAME USED VALUE
			do
				if [ $NAME = $LOAD_NAME ]; then
					echo $LOAD_NAME 0 $CURRENT >> $TEMP_LOG2
				else
					echo $NAME $USED $VALUE >> $TEMP_LOG2
				fi
			done < $TEMP_LOG
			mv $TEMP_LOG2 $TEMP_LOG
		fi
		# If flag was set send message to collector souls
		if [ $flag = "true" ]; then
			# Type of Message = SOUL_NAME HOST_NAME TEXT

echo "\n---------------------- EIS Command Center ----------------------\n" > $LOAD_LOG_AUTOJOB
echo "Automatic detection and operation by EIS Command Center\n" >> $LOAD_LOG_AUTOJOB
echo "Automatic add Virtual CPUs incase high workload into host : $HOST\n" >> $LOAD_LOG_AUTOJOB
date >> $LOAD_LOG_AUTOJOB
echo "System uptime" >> $LOAD_LOG_AUTOJOB
uptime >> $LOAD_LOG_AUTOJOB
echo "\n--- Show Virtual CPUs (before automatic add) ---" >> $LOAD_LOG_AUTOJOB
lparstat -i |grep 'Online Virtual CPUs' >> $LOAD_LOG_AUTOJOB
ssh hscroot@10.4.6.170 chhwres -r proc -m P780-Plus-MHD-SN0652C9T -o a -p PRD_bgcnsr_backup --procs 1
if [[ $? -eq 0 ]]
then
sleep 5
echo >> $LOAD_LOG_AUTOJOB
date >> $LOAD_LOG_AUTOJOB
echo "System uptime" >> $LOAD_LOG_AUTOJOB
uptime >> $LOAD_LOG_AUTOJOB
echo "\n--- Show Virtual CPUs (after automatic add) ---" >> $LOAD_LOG_AUTOJOB
lparstat -i |grep 'Online Virtual CPUs' >> $LOAD_LOG_AUTOJOB
echo "\nRecommended Action: No response action is required." >> $LOAD_LOG_AUTOJOB

echo "\n---------------------- By EIS Command Center ----------------------\n" >> $LOAD_LOG_AUTOJOB
else
echo "\n--- Show Virtual CPUs (after automatic add) ---\n" >> $LOAD_LOG_AUTOJOB
lparstat -i |grep 'Online Virtual CPUs' >> $LOAD_LOG_AUTOJOB
echo "\nRecommended Action: Please call to EIS Unix-Linux Admin Team for review" >> $LOAD_LOG_AUTOJOB
fi

			echo `date +"%d/%h/%y"` - `date +"%H:%M"`\\tLoad Average $LOAD_NAME $CURRENT >> $LOAD_LOG
	mail -s "Load Average Alert $LOAD_NAME $CURRENT on host: $HOST" suthanawan@bigc.co.th < $LOAD_LOG
	mail -s "EIS Command Center (Unix-Linux Team): Load Average Alert $LOAD_NAME $CURRENT on host: $HOST" command_center_alert@bigc.co.th,mis_enterprise_unix_and_linux_technology@bigc.co.th,nsoc@bigc.co.th,suthanawan@bigc.co.th < $LOAD_LOG_AUTOJOB
		fi
	fi
	done < $LOAD_CONFIG
	sleep $period
done
