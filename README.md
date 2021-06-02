
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

## Build it yourself on Alpine

```bash
CDN_URL="http://dl-cdn.alpinelinux.org/alpine/edge/main"
#
apk update --repository="${CDN_URL}"
apk upgrade --repository="${CDN_URL}"
apk add autoconf automake build-base cmake curl git libtool linux-headers perl pkgconf python3 python3-dev re2c tar --repository="${CDN_URL}"
apk add readline-dev readline-static ncurses-dev ncurses-static expat-dev expat-static libunistring-dev libunistring-static gettext-dev gettext-static zlib-dev zlib-static libidn-dev openssl-dev openssl-libs-static --repository="${CDN_URL}"
#
wget https://github.com/userdocs/lftp-static/raw/master/src/lftp-4.9.2.tar.gz
tar xf lftp-4.9.2.tar.gz
cd lftp-4.9.2
#
export CXXFLAGS="--static -static -std=c++14"
export CPPFLAGS="--static -static"
export LDFLAGS="--static -static"
#
./configure LIBS="-l:libreadline.a -l:libncursesw.a" --prefix="$HOME/test" --with-openssl --without-gnutls --enable-static --enable-threads=posix
make -j"$(nproc)"
make install
```