#!/bin/bash

log_message() {
	echo -e $1 >> $LOG_PATH
}

function restart_cis-agi() {

	/etc/init.d/cis-agi restart
}


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_PATH="$CURRENT_DIR/log_check-active-calls-restart-cis-agi"

	while true
		do
	log_message "\n\n\n\n\n----------- Checking System Info -----------"
	log_message "Checking Time:  $(date)"
		hours=`date "+%H"`
		if [ $hours -ge 8 ] && [ $hours -le 23 ]
			then
			log_message "Currently Hours = $hours, 08:59:59 < $hours < 23:59:59"
			date_time=`date "+%Y-%m-%d %H:%M:%S"`
			active_calls=`asterisk -vvvvvrx 'core show channels' | grep "active calls" | awk '{print $1}'`
				if [ $active_calls -le 0 ]
					then
						log_message "Check $date_time with active call = $active_calls (true)"
						restart_cis-agi > $LOG_PATH 2>&1 &
						log_message "$date_time execute restart service cis-agi"
						
					
				else
						log_message "Check $date_time with active calls = $active_calls (false)"
						log_message "$date_time not execute restart service cis-agi"
				fi
		else
			log_message "Currently Hours = $hours, $hours < 08:59:59 && $hours < 23:59:59"
			log_message "Not execute check time"
		fi
		log_message "==================================================================="
		sleep 60
	done &

