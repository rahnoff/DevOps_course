#!/bin/bash
echo "$USER ALL=(ALL) NOPASSWD: $PWD/script_first.sh" | sudo EDITOR='tee -a' /usr/sbin/visudo &> /dev/null
E_NOARGS=75
if [ "$#" -lt 3 ]
then
	echo "Usage: `basename $0` firefox 2 E or `basename $0` 5000 5 L"
	echo -e "firefox - process name, 5000 - PID, 2 - how many connections should be printed,\nE - ESTABLISHED state, L- LISTEN one, any other letter, for example A, is considered as all states"
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
	        sudo ss -tunap |
	        awk -v pid="$1" '$0~pid { print $2, $6 }'
        else
	        sudo netstat -tunapl |
	        awk -v pid="$1" '$0~pid { print $5, $6 }'
	fi
fi

sudo netstat -tunapl &> /dev/null
if [ $? != 0 ]
then
	if [ "$STATE" == "ESTABLISHED" ]
	then
		STATE="ESTAB"
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
			        awk -F':' '/^Organization/ {print $2} /^NetRange/ {print $2}' |
				awk 'ORS=NR%2?" ":"\n"' |
				awk '{count[$4]++} END {for (word in count) print word, count[word]}'
		        fi
	        done
	elif [ "$STATE" == "LISTEN" ]
	then
 	        sudo ss -tunap |
	        awk -v pid="$1" -v state="$STATE" '$0~pid {if($2 == state) print $2, $6}'
	fi
else
	if [ "$STATE" == "LISTEN" ]
	then
                sudo netstat -tunapl |
	        awk -v pid="$1" -v state="$STATE" '$0~pid {if($6 == state) print $5, $6}'
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
			        awk -F':' '/^Organization/ {print $2} /^NetRange/ {print $2}' |
                                awk 'ORS=NR%2?" ":"\n"' |
				awk '{count[$4]++} END {for (word in count) print word, count[word]}'
		        fi
	        done
	fi
fi)

if [ "$3" == "E" ]
then
        OUTPUT2=$(
	sudo netstat -tunapl &> /dev/null
	if [ "$?" != 0 ]
        then
		STATE2="ESTAB"
	        sudo ss -tunap |
	        awk -v pid="$1" -v state="$STATE2" '$0~pid {if($2 == state) print $6}' |
	        cut -d: -f1 |
	        sort |
	        uniq -c |
	        sort |
 	        tail -n 5 |
	        grep -oP '(\d+\.){3}\d+' |
	        while read IP
	        do
		        whois $IP |
			awk -F':' '/^Organization/ {print $2} /^NetRange/ {print $2}' |
		        awk 'ORS=NR%2?" ":"\n"' |
			awk '{print $1,$2,$3,$4,$5,$6,$7}'
	        done
	else
		STATE2="ESTABLISHED"
                sudo netstat -tunapl |
	        awk -v pid="$1" -v state="$STATE2" '$0~pid {if($6 == state) print $5}' |
	        cut -d: -f1 |
	        sort |
	        uniq -c |
	        sort |
	        tail -n 5 |
	        grep -oP '(\d+\.){3}\d+' |
	        while read IP
	        do
                        whois $IP |
			awk -F':' '/^Organization/ {print $2} /^NetRange/ {print $2}' |
		        awk 'ORS=NR%2?" ":"\n"' |
			awk '{print $1,$2,$3,$4,$5,$6,$7}'
	        done
	fi)
fi

if [ -z "$OUTPUT2" ]
then
	if [ -z "$OUTPUT" ]
	then
		echo "No such process or state"
	else
	        echo "$OUTPUT" |
	        sed -n "1,$2p"
	        exit "$?"
	fi
else
	echo "$OUTPUT" |
	sed -n "1,$2p"
	echo " "
        echo "$OUTPUT2" |
        sed -n "1,$2p"
	exit "$?"
fi
