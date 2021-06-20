#!/bin/bash

if [ -z "$1" ]
then
	echo "Usage: ./`basename $0` https://github.com/repo_maintainer/repo_name"
	exit 1
fi

GOVERNOR=$(echo "$1" | awk -F'//' '{print $2}' | awk -F'/' '{print $2}')
REPO_NAME=$(echo "$1" | awk -F'//' '{print $2}' | awk -F'/' '{print $3}')

NUMBER_OPEN_PRS=$(curl https://api.github.com/repos/$GOVERNOR/$REPO_NAME/pulls?state=all 2> /dev/null |
jq -jr '.[] | "PR_state:", " ",.state, "\n","Contributor_name:", (.user|" ",.login), "\n", "Label:", (.head |" ",.label), "\n"' |
awk 'ORS=NR%3?" ":"\n"' |
grep "open" |
wc -l)

if [ "$NUMBER_OPEN_PRS" = 0 ]
then
	echo "There are no open pull requests"
	exit 1
else
	echo "----------------------"
	echo "Open pull requests: "$NUMBER_OPEN_PRS""
	echo "----------------------"
fi

CONTRIBUTORS_PRS=$(curl https://api.github.com/repos/$GOVERNOR/$REPO_NAME/pulls?state=all 2> /dev/null |
jq -jr '.[] | "PR_state:", " ",.state, "\n","Contributor_name:", (.user|" ",.login), "\n"' |
awk 'ORS=NR%2?" ":"\n"' |
grep "open" |
awk '{count[$4]++} END {for (name in count) print name, count[name]}' |
awk '{if($2 > 1) print $1, ";", "Open PRs:", $2}')

if [ -z "$CONTRIBUTORS_PRS" ]
then
	echo "No contributors with more than 1 open PR"
	echo "----------------------------------------"
else
	echo "Contributors with more than 1 open PR:"
	echo "$CONTRIBUTORS_PRS"
	echo "--------------------------------------"
fi

CONTRIBUTORS_LABELS_PRS=$(curl https://api.github.com/repos/$GOVERNOR/$REPO_NAME/pulls?state=all 2> /dev/null |
jq -jr '.[] | "PR_state:", " ",.state, "\n","Contributor_name:", (.user|" ",.login), "\n", "Label:", (.head |" ",.label), "\n"' |
awk 'ORS=NR%3?" ":"\n"' |
grep "open" |
awk '{print $4, ";", $5, $6}')

echo "All open PRs with contributors and labels:"
echo "$CONTRIBUTORS_LABELS_PRS"
echo "------------------------------------------"
