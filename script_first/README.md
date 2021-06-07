## Network script<br />
The first command is `netstat` with `-tunapl` options, which is used to display socket statistics,  options:<br />
`-t` - show TCP sockets<br />
`-u` - show UDP sockets<br />
`-n` - show numbers instead of names for interfaces and ports<br />
`-a` - show listening and established sockets<br />
`-p` - show the process using the sockets<br />
`-l` - show only listening sockets<br />
The output of command:<br />
**Proto** - means protocol<br />
**Recv-Q, Send-Q** - received and sent data correspondingly<br />
**Local Address** - on which port and IP address the process is listening on, **0.0.0.0** stands for all network interfaces for IPv4, **:::** same for IPv6, **\*** for all ports<br />
**Foreign Address** - from which address and port connection is established<br />
**State** - **LISTEN** means the process is waiting, **ESTABLISHED** the process is processing input, UDP protocol doesn't have any state<br />
**PID/Program name** - PID of a process and its name<br />

`awk` - the tabular data manipulation tool, `/firefox/` - match only lines with firefox word, `{print $5}` - print the fifth column

`cut` - extracts a sections of text from a line, `-d':'` - delimeter is used for colon separating pattern in this case, `-f1` - print the first part of the string separated by colon 

`sort` - sorts the contents of standart input and sends the results to standart output

`uniq` - removes any duplicate lines from a sorted file or standart input and sends the results to standart output, often used with sort, `-c` - lines will be preceeded by the number of times the line occurs

`tail` - prints the last 10 lines from the file or standart input, `-n 5` option - print only 5 last lines

`grep` - general regular expression parser - searches text files for text matching a specified regular expression and outputs any line containing a match, options:<br />
`-o` is used for printing only matched text<br />
`-P` means Perl-compatible expression<br />
`(\d+\.)` - `\d` - text should start with a number in 0-9 range, `+` means one or more matches of the preceeding element, `\.` - backslash as an escaping char for point, point itself means any char<br />
`()` - parenthesis for integration three matches into one<br />
`{3}` - match the preceeding element three times

`while condition; do list; done` - while loop, commands in a list will be executed until condition is false

`read variable` - is used to read a single line of standart input or a line of data from a file, assigns fields from standart input to the specified variable, in this case one variable will contain all input

`whois` - determine which organisation owns the range of IP addresses

`-F':'` option in awk means field separator, in this case colon, `/^Organization/` - print the line which starts with Organization word, `{print $2}` - print the second part after colon
