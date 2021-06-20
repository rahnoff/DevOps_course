## GitHub script for open PRs

The script shows open pull requests, for short PRs, for a specified GitHub repo, requires one arg - link to repo<br />

First two vars contain maintainer and repo names, them vars used further<br />

**NUMBER_OPEN_PRS** var contains number of open PRs, if it's empty the script terminates with an error, the var itself consists of the following:<br/>
- `curl https://api.github.com/repos/maintainer_name/repo_name/pulls?state=all 2> /dev/null` - gets JSON info about repo's pull requests, since used further as input for `jq`, system info redirected to **/dev/null** by **2> /dev/null** for convenience<br />
- `jq -jr '.[] | "PR_state:", " ",.state, "\n", "Contributor_name:", (.user|" ",.login), "\n", "Label:", (.head|" ",.label), "\n"'` - JSON parser `jq` used to convert text to JSON and extract specified fields<br />
- `awk 'ORS=NR%3?" ":"\n"'` - prints every three rows on the same line<br />
- `grep "open"` - prints only lines with word **open**<br />
- `wc -l` - counts lines<br />

**CONTRIBUTORS_PRS** var contains contributors names with 2 or more open PRs, it's empty if no such contributors, the var consists of the following, only new lines described:<br />
- `awk '{count[$4]++} END {for (name in count) print name, count[name]}'` - counts how many times a name occurs in a list, then prints the name and a count, which represents open PRs<br />
- `awk '{if($2 > 1) print $1, ";", "Open PRs:", $2}'` - checks whether a number in a second field is bigger than 1, then prints both fields, output's empty if the condition's false<br />

**CONTRIBUTORS_LABELS_PRS** var contains contributor's name and a label<br />
