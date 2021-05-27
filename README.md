
This script is designed to be run and used on Alpine Linux stable via docker
## Docker

To build using docker run this command

```bash
docker run -it -v $HOME:/root alpine:latest /bin/ash -c 'apk update && apk add bash curl tar && cd && curl -sL git.io/JvOIC | bash -s all'
```

## Manual Instructions

We need `bash` to run this script and Alpine Linux defaults to `ash`

After you `ssh` into your server run this command to install `bash`.

Install these dependencies

~~~bash
apk add bash curl tar
~~~

## Download the script

~~~
wget -qO ~/build-script.sh https://git.io/JvOIC && chmod 700 ~/build-script.sh
~~~

Now you can use it like with this command:

~~~
~/build-script.sh
~~~


## Download lftp static x86_64 release

~~~
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp
chmod 700 ~/bin/lftp
~~~