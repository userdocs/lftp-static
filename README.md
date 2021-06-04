
Built on [Alpine linux](https://alpinelinux.org) edge

Static binaries are available here: https://github.com/userdocs/lftp-static/releases/latest

### Build Platforms

Alpine linux as the host OS.

Builds are created using https://github.com/multiarch/qemu-user-static and arch specific docker images detailed in the table below.

| Alpine Arch | Docker platform arch |  Docker hub image   |
| :---------: | :------------------: | :-----------------: |
|    armhf    |     linux/arm/v6     | arm32v6/alpine:edge |
|    armv7    |     linux/arm/v7     | arm32v7/alpine:edge |
|   aarch64   |     linux/arm64      | arm64v8/alpine:edge |
|   ppc64le   |    linux/ppc64le     | ppc64le/alpine:edge |
|    s390x    |     linux/s390x      |  s390x/alpine:edge  |
|     x86     |      linux/i386      |  i386/alpine:edge   |
|   x86_64    |     linux/amd64      |  amd64/alpine:edge  |

### Generic Build dependencies

Install the main build dependencies

~~~
apk add autoconf automake build-base curl git libtool linux-headers perl pkgconf python3 python3-dev tar
~~~

Install the lftp build dependencies

~~~
apk add expat-dev expat-static gettext-dev gettext-static libidn-dev libunistring-dev libunistring-static ncurses-dev ncurses-static openssl-dev openssl-libs-static readline-dev readline-static zlib-dev zlib-static
~~~

### Generic Build Instructions

Download the self hosted source code

```bash
curl -sL https://github.com/userdocs/lftp-static/raw/master/src/lftp-4.9.2.tar.gz -o lftp-4.9.2.tar.gz
tar xf lftp-4.9.2.tar.gz
cd lftp-4.9.2
```

Set some required build flags

```bash
export CXXFLAGS="--static -static -std=c++17"
export CPPFLAGS="--static -static"
export LDFLAGS="--static -static"
```

Configure

```bash
./configure LIBS="-l:libreadline.a -l:libncursesw.a" --prefix="$HOME" --with-openssl --without-gnutls --enable-static --enable-threads=posix
```

Build

```bash
make -j$(nproc)
make install
```

### Check the linking was done properly

```bash
ldd ~/bin/lftp
```

### Version

Use this command to check the version.

~~~
~/bin/lftp --version
~~~

Will show something like this.

**Note:** Libraries used: will be blank since it [only checks the dynamically linked libs](https://github.com/lavv17/lftp/issues/569). Ours are all statically linked

~~~
LFTP | Version 4.9.1 | Copyright (c) 1996-2020 Alexander V. Lukyanov

LFTP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LFTP.  If not, see <http://www.gnu.org/licenses/>.

Send bug reports and questions to the mailing list <lftp@uniyar.ac.ru>.

Libraries used:
~~~

### Use the static binaries from this repo

Download and install to the bin directory of your local user (for root this may not be in the `$PATH`)

Pick the platform URL you need:

i386 / x86

```bash
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp-i386
chmod 700 ~/bin/lftp
```

amd64

```bash
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp-amd64
chmod 700 ~/bin/lftp
```

arm32v6

```bash
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp-arm32v6
chmod 700 ~/bin/lftp
```

arm32v7

```bash
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp-arm32v7
chmod 700 ~/bin/lftp
```

aarch64 / arm64

```bash
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp-arm64v8
chmod 700 ~/bin/lftp
```

ppc64le

```bash
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp-ppc64le
chmod 700 ~/bin/lftp
```

s390x

```bash
mkdir -p ~/bin && source ~/.profile
wget -qO ~/bin/lftp https://github.com/userdocs/lftp-static/releases/latest/download/lftp-s390x
chmod 700 ~/bin/lftp
```

Check the version:

~~~
~/bin/lftp --version
~~~