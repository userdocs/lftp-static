
This script is designed to be run and used on Alpine Linux stable

I used Alpine Linux instances on https://www.scaleway.com/en/ for testing.

## Instructions

We need `bash` to run this script and Alpine Linux defaults to `ash`

After you `ssh` into your server run this command to install `bash`.

~~~
apk add bash
~~~

## Download the script

~~~
wget -qO ~/build-script.sh https://git.io/JvOIC && chmod 700 ~/build-script.sh
~~~

Now you can use it like with this command:

~~~
~/build-script.sh
~~~

## Download lftp static x86_64

~~~
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp
chmod 700 ~/bin/lftp
~~~