## Network script<br />

Shows connections established by a process on the local host<br />

The script requires three args, if them aren't specified, terminates with an error and usage example<br />

It uses `netstat` or `ss` depending on which one is installed<br />
The first command makes the script executable regardless of user privilegies<br />
The third arg is checked for a connection state, then the internal script variable is used for representing a state, for ESTABLISHED state script's output's two parts: the first one includes count of connections per organization and the second one's organization name with IP adresses range, also number of organizations' connections to be printed is controlled by the second script arg<br />

`ss` and `netstat`, which are used to display socket statistics, use almost same options:<br />
`-t` - show TCP sockets<br />
`-u` - show UDP sockets<br />
`-n` - show numbers instead of names for interfaces and ports<br />
`-a` - show listening and established sockets<br />
`-p` - show the process using the sockets<br />
`-l` - show only listening sockets<br />

`awk` - the tabular data manipulation tool:<br />
- `-v pid="$1" '$0~pid { print fields_depend_on_ss_or_netstat }'` - matches only lines with a specified process and prints fields of `ss` or `netstat`<br />
- `-v pid="$1" -v state="$STATE" '$0~pid {if(field_depends_on_ss_or_netstar == state) print fields_depending_on_ss_or_netstat_or_state}'` - matches only lines with a specified process and state and prints different fields<br />
- `-F':' '/^Organization/ {print $2} /^NetRange/ {print $2}'` - `-F':'` option in awk means field separator, in this case colon, `/^Organization/` - prints the column which starts with **Organization**, `{print $2}` - prints the value of this column, `/^NetRange/`, `{print $2}` - same meaning<br />
- `'ORS=NR%2?" ":"\n"'` - formats output into two columns<br />
- `'{count[$4++]} END {for (word in count) print word, count[word]}'` - counts how many times the fourth field occurs and prints the count with the field<br />
- `{print $1,$2,$3,$4,$5,$6,$7}` - prints lines with no leading space<br />

`cut` - extracts text sections from a line, `-d':'` - delimeter is used for colon separating pattern in this case, `-f1` - print the first part of the string separated by colon<br />

`sort` - sorts the contents of standart input and sends the results to standart output<br />

`uniq` - removes any duplicate lines from a sorted file or standart input and sends the results to standart output, often used with sort, `-c` - lines will be preceeded by the number of times the line occurs<br />

`tail` - prints the last 10 lines from the file or standart input, `-n 5` option - prints only last 5 lines<br />

`grep` - general regular expression parser - searches text files for text matching a specified regular expression and outputs any line containing a match, options:<br />
`-o` is used for printing only matched text<br />
`-P` means Perl-compatible expression<br />
`(\d+\.)` - `\d` - text should start with a number in 0-9 range, `+` means one or more matches of the preceeding element, `\.` - backslash as an escaping char for point, point itself means any char<br />
`()` - parenthesis for integration three matches into one<br />
`{3}` - match the preceeding element three times<br />

`while **condition**; do **list_of_commands**; done` - while loop, commands in a **list_of_commands** will be executed until condition is false<br />

`read **variable**` - is used to read a single line of standart input or a line of data from a file, assigns fields from standart input to the specified variable, in this case one variable will contain all input<br />

`whois` - determines which organization owns the range of IP addresses<br />

`sed -n "1,$2p"` - prints only range of lines<br /> 

`exit "$?"` - returns exit code of the preceeding command<br />

The whole script is two variables representing two different outputs, **OUTPUT** variable is a common output of the script, **OUTPUT2** makes sense only if the required state is **ESTABLISHED**<br />
