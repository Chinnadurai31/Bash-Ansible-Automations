#!/bin/bash

cpu=$(mpstat  | awk '{print$14}' | grep -Eo [0-9]* | head -n 1)
cpu_percent=$((100 - $cpu))
echo "current cpu usage percent $cpu_percent%"
ram=$(vmstat -s | awk '/total memory/{total=$1} /used memory/{used=$1} END {printf("%.2f\n", used/total * 100.0)}' | grep -oE [0-9]* | head -n 1)
disk=$(df / | awk '{print$5}' | grep -oE [0-9]*)
echo "current ram usage percent $ram%"
echo "current disk usage percent $disk%"
while true
do
	if [ "$cpu_percent" -gt 80 ]
	then

		slack_alert_cpu="{\"text\": \"CPU exceeded over $cpu_percent% please look into it\", \"username\": \"CI/CD bot\"}"
                curl -X POST -H 'Content-type: application/json' --data "$slack_alert_cpu" "$SLACK_WEBHOOK_URL"
	fi
	

	if [ "$ram" -gt 80 ]
	then
		slack_alert_ram="{\"text\": \"RAM exceeded over $ram% please look into it\", \"username\": \"Resource_monitoring\"}"
		curl -X POST -H 'Content-type: application/json' --data "$slack_alert_ram" "$SLACK_WEBHOOK_URL"
	fi
	
	if [ "$disk" -gt 80 ]
	then

		slack_alert_disk="{\"text\": \"Disk exceeded over $ram% please look into it\", \"username\": \"Resource_monitoring\"}"
                curl -X POST -H 'Content-type: application/json' --data "$slack_alert_disk" "$SLACK_WEBHOOK_URL"
	fi

	sleep 60
done


	            





          


