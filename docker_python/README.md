## Python Docker image

Python app supports GET and POST methods with json type of data as a request containing emoji, emoji text sound and count, responds with different number of emoji with text sounds depending on count value<br />

To test app with POST method type: `curl -H "Content-Type: application/json" -X POST -d'{"animal": "elephant", "sound": "whoaa", "count": 5}' http://localhost:8080`, with GET method: `curl http://localhost:8080`<br />

Source file is **server.py**, the executable of this file is **server_as_one**<br />

To compile Python files install **pyinstaller**: `pip3 install pyinstaller`, after installation **pyinstaller** isn't in the PATH, to add it there open **.profile**, which is in the home directory, and type on the new line: **PATH="$HOME/.local/bin:$PATH"; export PATH**, after that type: `source .profile` to make changes<br />

Now compile Python: `python3 -OO -m PyInstaller -F server.py`, in the same folder there are now few others, **dist** contains a compiled file, to make sure a compiled Python works just like a casual Python, go there and run the executable<br />

Next step is to get a statically linked executable for a Docker image, firstly install **autoconf** package: `sudo apt install autoconf`, then go to **/** dir and type:<br />
- `sudo wget https://github.com/NixOS/patchelf/archive/0.10.tar.gz`<br />
- `sudo tar xzf 0.10.tar.gz`<br />
- `cd patchelf-0.10`<br />
- `sudo ./bootstrap.sh`<br />
- `sudo ./configure`<br />
- `sudo make`<br />
- `sudo make install`<br />
Then type: `pip3 install staticx`, go back to **dist**, type `staticx --strip server server_as_one`, now there is a statically linked python executable, which can be executed in a Docker container<br />

To build a Docker image firstly create **tmp** folder in the src code directory, since **staticx** requires it to execute properly, Git doesn't recognize empty folders, that's why an empty file's there, then type: `docker image build -t name_of_image .` - builds an image form **scratch** - special Docker image, using a Dockerfile in the current directory<br />

To run a container with this app type: `docker container run name_of_image -p 8080:8080`, in case of Docker container **localhost** in **curl** doesn't work, container IP address is required, type: `docker container ls`, find the one with this app, then type: `docker container inspect container_name`, in the output bottom there's an IP address<br />
