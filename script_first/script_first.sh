#!/bin/bash
echo "$USER ALL=(ALL) NOPASSWD: $PWD/script_first.sh" | sudo EDITOR='tee -a' /usr/sbin/visudo &> /dev/null
E_NOARGS=75
if [ "$#" -lt 3 ]
then
	echo "Usage: `basename $0` firefox 2 E or `basename $0` 5000 5 L"
	echo -e "firefox - process name, 5000 - PID, 2 - how many lines of output should be printed,\nE is for ESTABLISHED state, L is for LISTEN one, any other letter is considered as all states"
	exit $E_NOARGS
fi

OUTPUT=$(
if [ "$3" == "E" ]
then
	STATE="ESTABLISHED"
elif [ "$3" == "L" ]
then
	STATE="LISTEN"
else
        sudo netstat -tunapl &> /dev/null
        if [ $? != 0 ]
        then
	        #echo "netstat isn't installed, ss is used instead"
	        sudo ss -tunap |
	        awk -v pid="$1" '$0~pid { print $6 }' |
	        cut -d: -f1 |
		sort |
	        uniq -c |
	        sort |
	        tail -n 5 |
	        grep -oP '(\d+\.){3}\d+' |
	        while read IP
	        do
		        whois $IP |
		        if [ $? != 0 ]
		        then
			        echo "whois isn't installed"
			        exit 1
		        else
			        awk -F':' '/Organization/ {print $2} /NetRange/ {print $2}'
		        fi
	        done
         else
	        sudo netstat -tunapl |
	        awk -v pid="$1" '$0~pid { print $5 }' |
	        cut -d: -f1 |
	        sort |
	        uniq -c |
	        sort |
 	        tail -n 5 |
	        grep -oP '(\d+\.){3}\d+' |
	        while read IP
	        do
		        whois $IP |
		        if [ $? != 0 ]
		        then
			        echo "whois isn't installed"
			        exit 1
		        else
			        awk -F':' '/Organization/ {print $2} /NetRange/ {print $2}'
		        fi
	        done
	fi
	exit 0
fi

sudo netstat -tunapl &> /dev/null
if [ $? != 0 ]
then
	if [ "$STATE" == "ESTABLISHED" ]
	then
		STATE="ESTAB"
                #echo "netstat isn't installed, ss is used instead"
	        sudo ss -tunap |
	        awk -v pid="$1" -v state="$STATE" '$0~pid {if($2 == state) print $6}' |
	        cut -d: -f1 |
	        sort |
	        uniq -c |
	        sort |
 	        tail -n 5 |
	        grep -oP '(\d+\.){3}\d+' |
	        while read IP
	        do
		        whois $IP |
		        if [ $? != 0 ]
		        then
			        echo "whois isn't installed"
			        exit 1
		        else
			        awk -F':' '/Organization/ {print $2} /NetRange/ {print $2}'
		        fi
	        done
	elif [ "$STATE" == "LISTEN" ]
	then
                #echo "netstat isn't installed, ss is used instead"
 	        sudo ss -tunap |
	        awk -v pid="$1" -v state="$STATE" '$0~pid {if($2 == state) print $6}' |
	        cut -d: -f1 |
	        sort |
	        uniq -c |
	        sort |
	        tail -n 5 |
	        grep -oP '(\d+\.){3}\d+' |
	        while read IP
                do
		        whois $IP |
		        if [ $? != 0 ]
		        then
			        echo "whois isn't installed"
			        exit 1
		        else
			        awk -F':' '/Organization/ {print $2} /NetRange/ {print $2}'
		        fi
	        done
	fi
else
	sudo netstat -tunapl |
	awk -v pid="$1" -v state="$STATE" '$0~pid {if($6 == state) print $5}' |
	cut -d: -f1 |
	sort |
	uniq -c |
	sort |
	tail -n 5 |
	grep -oP '(\d+\.){3}\d+' |
	while read IP
	do
		whois $IP |
		if [ $? != 0 ]
		then
			echo "whois isn't installed"
			exit 1
		else
			awk -F':' '/Organization/ {print $2} /NetRange/ {print $2}'
		fi
	done
fi)


	#awk -v pid="$1" -v state="$3" '$0~pid {if($6 == state) print $5}' |
        #cut -d: -f1 |
        #sort |
        #uniq -c |
        #sort |
        #tail -n 5 |
        #grep -oP '(\d+\.){3}\d+' |
        #while read IP
        #do
	        #whois $IP |
	        #if [ $? != 0 ]
		#then
		 #       echo "whois isn't installed"
		#	exit 1
		#else
		 #       awk -F':' '/^Organization/ {print $2}'
		#	exit 0
		#fi
	#done)



if [ -z "$OUTPUT" ]
then
	echo "No such state or whois can't determine an organization"
	exit 1
else
	echo "$OUTPUT" |
        awk 'ORS=NR%2?" ":"\n"' |
	#sed -n "1,$2p" |
	sort |
	uniq -c
        #sort |
        #uniq -c |
        #sort |
        #awk -v output="$STATE" '{print $5, $6, $7, $8, " ", $2, $3, $4, output, " ", "number of connections", " ", $1}'
        #head -n "$2"
fi
#awk 'ORS=NR%2?" ":"\n"' |
#sort |
#uniq -c |
#sort |
#awk -v output="$STATE" '{print $5, $6, $7, $8, " ", $2, $3, $4, output, " ", "number of connections", " ", $1}'
#tail -n "$2"
