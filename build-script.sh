#! /usr/bin/env bash
#
# Copyright 2019 by userdocs and contributors
#
# SPDX-License-Identifier: Apache-2.0
#
# @author - userdocs
#
# @credits - https://gist.github.com/notsure2
#
## https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
#
set -e
#
## Define some special arguments we can use to set the build directory without editing the script.
#
PARAMS=""
BUILD_DIR=""
SKIP_DELETE='no'
#
while (("$#")); do
	case "$1" in
		-b | --build-directory)
			BUILD_DIR=$2
			shift 2
			;;
		-nodel | --no-delete)
			SKIP_DELETE='yes'
			shift
			;;
		-h | --help)
			echo -e "\n\e[1mDefault build location:\e[0m \e[32m$HOME/build\e[0m"
			echo -e "\n\e[32m-b\e[0m or \e[32m--build-directory\e[0m to set the location of the build directory. Paths are relative to the script location. Recommended that you use a full path."
			echo -e "\n\e[32mall\e[0m - install all modules to the default or specific build directory (when -b is used)"
			#
			echo -e "\n\e[1mExample:\e[0m \e[32m$(basename -- "$0") all\e[0m - Will install all modules and build lftp to the default build location"
			echo -e "\n\e[1mExample:\e[0m \e[32m$(basename -- "$0") all -b \"\$HOME/build\"\e[0m - Will specify a build directory and install all modules to that custom location"
			echo -e "\n\e[1mExample:\e[0m \e[32m$(basename -- "$0") module\e[0m - Will install a single module to the default build location"
			echo -e "\n\e[1mExample:\e[0m \e[32m$(basename -- "$0") module -b \"\$HOME/build\"\e[0m - will specify a custom build directory and install a specific module use to that custom location"
			#
			echo -e "\n\e[32mmodule\e[0m - install a specific module to the default or defined build directory"
			echo -e "\n\e[1mSupported modules\e[0m"
			echo -e "\n\e[95mreadline\ncurses\nexpat\nlibiconv\nlinunistring\ngettext\nlibidn\nzlib\nopenssl\nlftp\e[0m"
			#
			echo -e "\n\e[1mPost build options\e[0m"
			echo -e "\nThe binary can be installed using the install argument."
			echo -e "\n\e[32m$(basename -- "$0") install\e[0m"
			echo -e "\nIf you installed to a specified build directory you need to specify that location using -b"
			echo -e "\n\e[32m$(basename -- "$0") install -b \"\$HOME/build\"\e[0m"
			#
			echo -e "\nThe installation directories depend on the user executing the script."
			echo -e "\nroot = \e[32m/usr/local\e[0m"
			echo -e "\nlocal = \e[32m\$HOME/bin\e[0m\n"
			exit 1
			;;
		--) # end argument parsing
			shift
			break
			;;
		-*) # unsupported flags
			echo -e "\nError: Unsupported flag - \e[31m$1\e[0m - use \e[32m-h\e[0m or \e[32m--help\e[0m to see the valid options\n" >&2
			exit 1
			;;
		*) # preserve positional arguments
			PARAMS="$PARAMS $1"
			shift
			;;
	esac
done
#
## Set positional arguments in their proper place.
#
eval set -- "$PARAMS"
#
## The build and installation directory. If the argument -b is used to set a build dir that directory is set and used. If nothing is specifed or the switch is not used it defaults to the hardcoed ~/build
#
[[ -n "$BUILD_DIR" ]] && export install_dir="$BUILD_DIR" || export install_dir="$HOME/build"
#
## Echo the build directory.
#
echo -e "\n\e[1mInstall Prefix\e[0m : \e[32m$install_dir\e[0m"
#
## Some basic help
#
echo -e "\n\e[1mScript help\e[0m : \e[32m$(basename -- "$0") -h\e[0m"
#
## This is a list of all modules.
#
modules='^(all|readline|ncurses|expat|libiconv|libunistring|gettext|libidn|zlib|openssl|lftp)$'
#
## The installation is modular. You can select the parts you want or need here or using ./scriptname module or install everything using ./scriptname all
#
[[ "$1" = 'all' ]] && skip_readline='no' || skip_readline='yes'
[[ "$1" = 'all' ]] && skip_ncurses='no' || skip_ncurses='yes'
[[ "$1" = 'all' ]] && skip_expat='no' || skip_expat='yes'
[[ "$1" = 'all' ]] && skip_libiconv='no' || skip_libiconv='yes'
[[ "$1" = 'all' ]] && skip_libunistring='no' || skip_libunistring='yes'
[[ "$1" = 'all' ]] && skip_gettext='no' || skip_gettext='yes'
[[ "$1" = 'all' ]] && skip_libidn='no' || skip_libidn='yes'
[[ "$1" = 'all' ]] && skip_zlib='no' || skip_zlib='yes'
[[ "$1" = 'all' ]] && skip_openssl='no' || skip_openssl='yes'
[[ "$1" = 'all' ]] && skip_lftp='no' || skip_lftp='yes'
#
## Set this to assume yes unless set to no by a dependency check.
#
deps_installed='yes'
#
## Check for required and optional dependencies
#
echo -e "\n\e[1mChecking if required core dependencies are installed\e[0m\n"
#
[[ -n "$(apk info -e bash)" ]] && echo -e "Dependency - \e[32mOK\e[0m - bash" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - bash"
}
[[ -n "$(apk info -e bash-completion)" ]] && echo -e "Dependency - \e[32mOK\e[0m - bash-completion" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - bash-completion"
}
[[ -n "$(apk info -e build-base)" ]] && echo -e "Dependency - \e[32mOK\e[0m - build-base" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - build-base"
}
[[ -n "$(apk info -e pkgconf)" ]] && echo -e "Dependency - \e[32mOK\e[0m - pkgconf" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - pkgconf"
}
[[ -n "$(apk info -e autoconf)" ]] && echo -e "Dependency - \e[32mOK\e[0m - autoconf" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - autoconf"
}
[[ -n "$(apk info -e automake)" ]] && echo -e "Dependency - \e[32mOK\e[0m - automake" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - automake"
}
[[ -n "$(apk info -e libtool)" ]] && echo -e "Dependency - \e[32mOK\e[0m - libtool" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - libtool"
}
[[ -n "$(apk info -e git)" ]] && echo -e "Dependency - \e[32mOK\e[0m - git" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - git"
}
[[ -n "$(apk info -e perl)" ]] && echo -e "Dependency - \e[32mOK\e[0m - perl" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - perl"
}
[[ -n "$(apk info -e linux-headers)" ]] && echo -e "Dependency - \e[32mOK\e[0m - linux-headers" || {
	deps_installed='no'
	echo -e "Dependency - \e[31mNO\e[0m - linux-headers"
}
#
## Check if user is able to install the depedencies, if yes then do so, if no then exit.
#
if [[ "$deps_installed" = 'no' ]]; then
	if [[ "$(id -un)" = 'root' ]]; then
		#
		echo -e "\n\e[32mUpdating\e[0m\n"
		#
		echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main/' > /etc/apk/repositories
		echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
		#
		set +e
		#
		apk update
		apk upgrade
		apk fix
		#
		set -e
		#
		[[ -f /var/run/reboot-required ]] && {
			echo -e "\n\e[31mThis machine requires a reboot to continue installation. Please reboot now.\e[0m\n"
			exit
		} || :
		#
		echo -e "\n\e[32mInstalling required dependencies\e[0m\n"
		#
		apk add bash bash-completion build-base pkgconf autoconf automake libtool git tar perl linux-headers
		#
		echo -e "\n\e[32mDependencies installed!\e[0m"
		#
		deps_installed='yes'
		#
	else
		echo -e "\n\e[1mPlease request or install the missing core dependencies before using this script\e[0m"
		#
		echo -e '\napk add bash bash-completion build-base pkgconf autoconf automake libtool git perl linux-headers\n'
		#
		exit
	fi
fi
#
## All checks passed echo
#
if [[ "$deps_installed" = 'yes' ]]; then
	echo -e "\n\e[1mGood, we have all the core dependencies installed, continuing to build\e[0m"
fi
#
## post build install command via positional parameter.
#
if [[ "$1" = 'install' ]]; then
	if [[ -f "$install_dir/lftp-static/bin/lftp" ]]; then
		#
		if [[ "$(id -un)" = 'root' ]]; then
			cp -rf "$install_dir/lftp-static/". "/usr/local"
		else
			mkdir -p "$HOME/bin"
			cp -rf "$install_dir/lftp-static/". "$HOME/bin"
		fi
		#
		echo -e '\nlftp has been installed - run it using this command:\n'
		#
		[[ "$(id -un)" = 'root' ]] && echo -e '\e[32mlftp\e[0m\n' || echo -e '\e[32m~/bin/lftp\e[0m\n'
		#
		exit
	else
		echo -e "\nlftp has not been built to the defined install directory:\n"
		echo -e "\e[32m$install_dir\e[0m\n"
		echo -e "Please build it using the script first then install\n"
		#
		exit
	fi
fi
#
## Create the configured install directory.
#
[[ "$1" =~ $modules ]] && mkdir -p "$install_dir" || :
#
## Set lib and include directory paths based on install path.
#
export include_dir="$install_dir/include"
export lib_dir="$install_dir/lib"
#
## Set some build settings we need applied
#
export CXXFLAGS="-std=c++14"
export CPPFLAGS="--static -static -I$include_dir"
export LDFLAGS="--static -static -L$lib_dir"
#
## Define some build specific variables
#
export PATH="$install_dir/bin:$HOME/bin${PATH:+:${PATH}}"
export LD_LIBRARY_PATH="-L$lib_dir"
export PKG_CONFIG_PATH="-L$lib_dir/pkgconfig"
#
## a download and extract function
#
download_file() {
	url_filename="${2}"
	echo -e "\n\e[32mInstalling $1\e[0m\n"
	file_filename="$install_dir/$1.tar.gz"
	[[ -f "$file_filename" ]] && rm -rf {"${install_dir}"/"$(tar tf "$file_filename" | grep -Eom1 "(.*)[^/]")","${file_filename}"}
	wget -qO "$file_filename" "${url_filename}"
	tar xf "$file_filename" -C "$install_dir"
	cd "$install_dir/$(tar tf "$file_filename" | head -1 | cut -f1 -d"/")"
}
#
## a file deletion function
#
delete_file() {
	if [[ "$SKIP_DELETE" = 'no' ]]; then
		if [[ "$2" = 'last' ]]; then
			echo -e "\n\e[91mDeleting $1 installation files\e[0m\n"
		else
			echo -e "\n\e[91mDeleting $1 installation files\e[0m"
		fi
		#
		file_filename="$install_dir/$1.tar.gz"
		[[ -f "$file_filename" ]] && rm -rf {"${install_dir}"/"$(tar tf "$file_filename" | grep -Eom1 "(.*)[^/]")","${file_filename}"}
	fi
	#
	if [[ "$SKIP_DELETE" = 'yes' ]]; then
		if [[ "$2" = 'last' ]]; then
			echo -e "\n\e[91mSkipping $1 installation files deletion\e[0m\n"
		else
			echo -e "\n\e[91mSkipping $1 installation files deletion\e[0m"
		fi
	fi
}
#
## Install readline from source
#
if [[ "$skip_readline" = 'no' || "$1" = 'readline' ]]; then
	#
	download_file "readline" "https://ftp.gnu.org/pub/gnu/readline/$(curl -sNL http://ftp.gnu.org/gnu/readline/ | grep -Eo 'readline-([0-9]{1,3}[.]?)([0-9]{1,3}[.]?)([0-9]{1,3}?)\.tar.gz' | sort -V | tail -1)"
	#
	./configure --prefix="$install_dir" --disable-install-examples --enable-static --disable-shared CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install
	#
	delete_file "readline"
	#
else
	echo -e "\nSkipping \e[95mreadline\e[0m module installation"
fi
#
## Install ncurses from source
#
if [[ "$skip_ncurses" = 'no' || "$1" = 'ncurses' ]]; then
	#
	download_file "ncurses" "https://ftp.gnu.org/pub/gnu/ncurses/$(curl -sNL http://ftp.gnu.org/gnu/ncurses/ | grep -Eo 'ncurses-([0-9]{1,3}[.]?)([0-9]{1,3}[.]?)([0-9]{1,3}?)\.tar.gz' | sort -V | tail -1)"
	#
	./configure --with-normal --prefix="$install_dir" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install
	#
	delete_file "ncurses"
	#
else
	[[ "$skip_readline" = 'no' ]] || [[ "$skip_readline" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mncurses\e[0m module installation"
	[[ "$skip_readline" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mncurses\e[0m module installation" || :
fi
#
## Install expat from source
#
if [[ "$skip_expat" = 'no' ]] || [[ "$1" = 'expat' ]]; then
	#
	download_file "expat" "$(curl -sNL https://api.github.com/repos/libexpat/libexpat/releases/latest | grep -Eom1 'ht(.*)expat-(.*)\.tar\.gz')"
	#
	./configure --prefix="$install_dir" --enable-static --disable-shared CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install
	#
	delete_file "expat"
	#
else
	[[ "$skip_ncurses" = 'no' ]] || [[ "$skip_ncurses" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mexpat\e[0m module installation"
	[[ "$skip_ncurses" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mexpat\e[0m module installation" || :
fi
#
## Install unistring from source
#
if [[ "$skip_libunistring" = 'no' || "$1" = 'libunistring' ]]; then
	#
	download_file "libunistring" "https://ftp.gnu.org/pub/gnu/libunistring/$(curl -sNL http://ftp.gnu.org/gnu/libunistring/ | grep -Eo 'libunistring-([0-9]{1,3}[.]?)([0-9]{1,3}[.]?)([0-9]{1,3}?)\.tar.gz' | sort -V | tail -1)"
	#
	./configure --prefix="$install_dir" --enable-static --disable-shared CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install
	#
	delete_file "libunistring"
	#
else
	[[ "$skip_expat" = 'no' ]] || [[ "$skip_expat" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mlibunistring\e[0m module installation"
	[[ "$skip_expat" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mlibunistring\e[0m module installation" || :
fi
#
## Install iconv from source
#
if [[ "$skip_libiconv" = 'no' || "$1" = 'libiconv' ]]; then
	#
	download_file "libiconv" "https://ftp.gnu.org/pub/gnu/libiconv/$(curl -sNL http://ftp.gnu.org/gnu/libiconv/ | grep -Eo 'libiconv-([0-9]{1,3}[.]?)([0-9]{1,3}[.]?)([0-9]{1,3}?)\.tar.gz' | sort -V | tail -1)"
	#
	./configure --prefix="$install_dir" --enable-static --disable-shared CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install
	#
	delete_file "libiconv"
	#
else
	[[ "$skip_libunistring" = 'no' ]] || [[ "$skip_libunistring" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mlibiconv\e[0m module installation"
	[[ "$skip_libunistring" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mlibiconv\e[0m module installation" || :
fi
#
## Install gettext from source
#
if [[ "$skip_gettext" = 'no' || "$1" = 'gettext' ]]; then
	#
	download_file "gettext" "https://ftp.gnu.org/pub/gnu/gettext/$(curl -sNL http://ftp.gnu.org/gnu/gettext/ | grep -Eo 'gettext-([0-9]{1,3}[.]?)([0-9]{1,3}[.]?)([0-9]{1,3}?)\.tar.gz' | sort -V | tail -1)"
	#
	./configure --prefix="$install_dir" --enable-static --disable-shared --with-libpth-prefix="$install_dir" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install
	#
	delete_file "gettext"
	#
else
	[[ "$skip_libiconv" = 'no' ]] || [[ "$skip_libiconv" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mgettext\e[0m module installation"
	[[ "$skip_libiconv" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mgettext\e[0m module installation" || :
fi
#
## Install idn2 from source
#
if [[ "$skip_libidn" = 'no' || "$1" = 'libidn' ]]; then
	#
	download_file "libidn" "https://ftp.gnu.org/pub/gnu/libidn/$(curl -sNL http://ftp.gnu.org/gnu/libidn/ | grep -Eo 'libidn2-([0-9]{1,3}[.]?)([0-9]{1,3}[.]?)([0-9]{1,3}?)\.tar.gz' | sort -V | tail -1)"
	#
	./configure --prefix="$install_dir" --with-libiconv-prefix="$install_dir" --with-libunistring-prefix="$install_dir" --with-libintl-prefix="$install_dir" --enable-static --disable-shared CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install
	#
	delete_file "libidn"
	#
else
	[[ "$skip_gettext" = 'no' ]] || [[ "$skip_gettext" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mlibidn\e[0m module installation"
	[[ "$skip_gettext" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mlibidn\e[0m module installation" || :
fi
#
## Install zlib from source
#
if [[ "$skip_zlib" = 'no' || "$1" = 'zlib' ]]; then
	#
	download_file "zlib" "https://github.com$(curl -sNL https://github.com/madler/zlib/releases | grep -Eo '/madler/zlib/archive/(.*).tar.gz' | sort -V | tail -1)"
	#
	./configure --prefix="$install_dir" --static
	make -j"$(nproc)" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make install
	#
	delete_file "zlib"
	#
else
	[[ "$skip_libidn" = 'no' ]] || [[ "$skip_libidn" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mzlib\e[0m module installation"
	[[ "$skip_libidn" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mzlib\e[0m module installation" || :
fi
#
## Install openssl from source
#
if [[ "$skip_openssl" = 'no' || "$1" = 'openssl' ]]; then
	#
	download_file "openssl" "https://github.com$(curl -sNL https://github.com/openssl/openssl/releases | grep -Eo '/openssl/openssl/archive/refs/tags/OpenSSL_1_1_1(.*).tar.gz' | head -n 1)"
	#
	./config --prefix="$install_dir" threads no-shared no-dso no-comp CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
	make -j"$(nproc)"
	make install_sw install_ssldirs
	#
	delete_file "openssl"
	#
else
	[[ "$skip_zlib" = 'no' ]] || [[ "$skip_zlib" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mopenssl\e[0m module installation"
	[[ "$skip_zlib" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mopenssl\e[0m module installation" || :
fi
#
## Install lftp from source
#
if [[ "$skip_lftp" = 'no' || "$1" = 'lftp' ]]; then
	#
	download_file "lftp" "https://github.com/userdocs/lftp-static/raw/master/src/lftp-4.9.2.tar.gz"
	#
	./configure LIBS="-lintl -liconv -lunistring -lexpat -lidn2 -ltextstyle -lgettextpo -lcharset -lasprintf -lpanel -lmenu -lform -lz -lhistory -lreadline -lncurses -lssl -lcrypto" --prefix="$install_dir/lftp-static" --host=x86_64 --enable-threads=posix --enable-static --disable-shared --without-gnutls --with-libiconv-prefix="$install_dir" --with-libintl-prefix="$install_dir" --with-zlib="$install_dir" --with-libidn2="$install_dir" --with-expat="$install_dir" --with-openssl="$install_dir" --with-readline="$install_dir" --with-readline-inc="$include_dir" --with-readline-lib="$lib_dir/libreadline.a -lncurses"
	make -j"$(nproc)"
	make install
	#
	delete_file "lftp" last
	#
	echo -e "\e[95mlftp\e[0m was installed to \e[32m$install_dir/lftp-static\e[0m\n"
	#
else
	[[ "$skip_openssl" = 'no' ]] || [[ "$skip_openssl" = 'yes' && "$1" =~ $modules ]] && echo -e "\nSkipping \e[95mlftp\e[0m module installation\n"
	[[ "$skip_openssl" = 'yes' && ! "$1" =~ $modules ]] && echo -e "Skipping \e[95mlftp\e[0m module installation\n" || :
fi
#
## exit the script
#
exit
