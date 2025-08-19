# Script for auto add Memory on AIX server
# Author : Mr.Thanawan Sukanta
# 24 Jun 2025
#
cd /bigc/script
MYDATE=`date +"%d%m"`
DAY=`date +"%m%d"`
log=/bigc/script/log/errpt/check_paging.log$MYDATE
#PAGING_MAX=35
PAGING_MAX=10
i=`hostname`
>$log
   lsps -a | tail -1 | awk '{print $5}'
   if [[ $? -eq 0 ]]
   then
       pging=`lsps -a | tail -1 | awk '{print $5}'`
#       if [[ $pging -gt $PAGING_MAX ]]
        if [[ $pging -gt $PAGING_MAX ]]
       then
        echo "\n---------------------- EIS Command Center ----------------------\n" >>$log
        echo "Automatic detection and operation by EIS Command Center\n" >>$log
        echo "Automatic hot add memory into host: $i (used more paging space ${pging} %) \n" >>$log
        echo "Host ${i} memory < before add memory > \n"  >>$log
        prtconf -m >> $log
        echo "Auto increase memory 512 MB to $i \n">>$log
#       ssh hscroot@10.4.6.169 chhwres -r mem -m RD-P980-9080-M9S-SN78270E8 -o a -p dev_bgcecpdb02_2020 -q 512
	ssh hscroot@10.4.6.169 chhwres -r mem -m RD-P10-S1024-9105-42A-SN789EE81 -o a -p new_dev_oracledb_11g -q 512
##       chps -d 1 hd6 # "flush data on hd6 "
	 sleep 5
##       chps -s 1 hd6 # "Increase size back to hd6 "
        echo "Host ${i} memory < after add memory > \n"  >>$log
        prtconf -m >> $log
echo "\nRecommended Action: If memory size increase, No response action is required."	>> $log
echo "\nRecommended Action: If memory size still same before/after, Please call to EIS Unix-Linux Admin Team for review" >> $log
        echo "\n---------------------- By EIS Command Center ----------------------\n" >>$log
        mail -s "EIS Command Center (Unix-Linux Team): Found more paging space $pging % on host ${i}, Automatic increse memory at `hostname`" command_center_alert@bigc.co.th,mis_enterprise_unix_and_linux_technology@bigc.co.th,nsoc@bigc.co.th,suthanawan@bigc.co.th <$log 
       fi
   fi

