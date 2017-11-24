#!/bin/bash

source /opt/monitor/monitorDB
newthreadNumber=1

now=$(date +%s)
#now=$(date --date="19:01" +%s)
begin=$(date --date="$lowCPUFrom" +%s)
end=$(date --date="$lowCPUTo" +%s)

#Verifica se existe o monitor ID para executar esse processo
if [ -f "/var/run/monitord.pid" ]
then

        echo "$threadMax"
        echo "ok"

        if [(("$threadMax" = "1)" && ("$threadMin" = "0"))]
        then
                newthreadNumber=1
        else
                if [ "$begin" -le "$now" -a "$now" -le "$end" ]
                then
                        if [ "$lowCPU"="true" ]
                        then
                                newthreadNumber=1
                        else
                                newthreadNumber=$((RANDOM% $threadMax + $threadMin))
                        fi
                else
                        newthreadNumber=$((RANDOM% $threadMax + $threadMin))
                fi
        fi

        sed -e "s%threadNumber=$threadNumber%threadNumber=$newthreadNumber%g" /opt/monitor/monitorDB \
                > /opt/monitor/monitorDB.tmp

        mv /opt/monitor/monitorDB.tmp /opt/monitor/monitorDB


        if [ "$waitTime" = "0"]
        then
                if [ "$threadNumber" != "$newthreadNumber" ]
               then
                        /etc/init.d/monitor stop
                        /etc/init.d/monitor start
                fi
        else
                if [ "$threadNumber" != "$newthreadNumber" ]
                then

                        echo "99"
                        #/etc/init.d/monitor stop
                        #/etc/init.d/monitor start
                fi

                #Get a ROANDOM valeu beteew 1 and waitTime in minuts
                point=$((RANDOM% $waitTime + 1))
                work=$((RANDOM% $workuntil + 1))
                next=$(date --date="$startAgain" +%s)

                #Verifica se a hora atual é maior que StartAgin and StopAgaing
                #        08:00          08:01       06:00         08:01
                if [ "$startAgain" -le "$now" && "$stopAgin" -le "$now" ]
                then

                        /etc/init.d/monitor stop

                        sed -e "s%threadNumber=$threadNumber%threadNumber=$newthreadNumber%g" /opt/monitor/monitorDB \
                                > /opt/monitor/monitorDB.tmp

                        mv /opt/monitor/monitorDB.tmp /opt/monitor/monitorDB

                        /etc/init.d/monitor stop
                else
echo "s"
                fi
        fi


fi
