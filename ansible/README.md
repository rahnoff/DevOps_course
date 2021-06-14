# Flask App with Ansible

Install Ansible by `sudo apt install ansible`

In **/etc/hosts** add an IP address and name of the managed Ansible host, in **/etc/ansible/hosts** add a line of hosts group name, in this case **[devops]**, on the next line add name of the managed Ansible host<br />

To use playbook make ssh pair of keys by typing `ssh-keygen` at Ansible host, then type `ssh-copy-id user_on_managed_host@name_of_managed_host`<br />

**main.yml** is the main playbook, others included as roles<br />

**flask_dir** is a source code folder<br />

**template** folder is for Nginx config file with Jinja extension<br />

**roles** folder contains:<br />

- **flaskpy** role is all about installing required python libs for Flask and configuring app on a remote host<br />

- **firewall_config** role installs and configures ufw to allow only 22, 8080, 443 ports<br />

- **ssh_config** role adds the remote user to sudoers, disables root login and also disables password-based SSH authentication<br />

- **systemd_config** role creates a unit to start the app at boot<br />

- **self_certs** role makes python3 default on target, installs dependencies for Ansible openssl\* modules and uses them to create self-signed certs for HTTPS proxy traffic in Nginx<br />

- **nginx_config** installs **Nginx** and configures it as an HTTPS proxy for Flask app<br />

**vars** folder is for variables, **vars.yml** contains:<br />
- **flask_app_location: "/usr/local/opt/flask_app"**
- **certificate_dir: "/etc/ssl/private"**
- **server_hostname: "debiandevopstarget"**

Flask app supports GET and POST methods with json type of data as a request containing emoji, emoji text sound and count, responds with different number of emoji with text sounds depending on count value<br />

To test app with POST method type: `curl -k -H "Content-Type: application/json" -X POST -d'{"animal": "elephant", "sound": "whoaa", "count" : 5}' https://name_of_managed_host/emoji`<br />
`-k` option is for ignoring self-signed certs, by default curl doesn't work with them<br />
`-H` option indicates the type of data being sent in the request body<br />
`-X POST` - POST method<br />
`-d` option indicates the data to include in the body of the request, **elephant** is emoji, **animal** is a key for it, **whoaa** is what elephants say, **count** is for how many times emoji should appear<br />
For GET method with Flask greetings type `curl -k https://name_of_managed_host/`<br />

To run the playbook type: `ansible-playbook flask_app_real.yml --become --become-user=root --ask-become-pass`<br />
`--ask-become-pass` option means the password is required<br />
`--become` tells Ansible to become a different user<br />
`--become-user=root` tells Ansible that user is root<br />

There is a possibility playbook files contain sensitive data like passwords, to provide additional security Ansible can encrypt such files with `ansible-vault encrypt file_name.yml` command, it demands a password, enter it and file_name.yml will no longer contain YAML, instead there are numbers. Next time the playbook runs it will demand a password. The convenient way to run playbooks with encrypted files is to create a password file. Inside **.ansible** folder which should be in a folder where you run a playbook, if not make it, create **vault_pass.txt** file with your password, set permissions to 600 by typing `chmod 600 vault_pass.txt`. When run the playbook use `--vault-password-file .ansible/vault_pass.txt` option. I encrypted **vars/vars.yml** file. To run the playbook with an encrypted file type `ansible-playbook flask_app_real.yml --become --become-user=root --ask-become-pass --vault-password-file .ansible/vault_pass.txt`<br />
