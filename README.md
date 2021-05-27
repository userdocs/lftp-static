
This script is designed to be run and used on Alpine Linux stable.

I used Alpine Linux instances on https://www.scaleway.com/en/ for testing.

### Instructions

We need `bash` to run this script and Alpine Linux defaults to `ash`

After you `ssh` into your server run this command to install `bash`.

~~~
apk add bash
~~~

### Download the script.

~~~
wget -qO ~/build-script.sh https://git.io/JvOIC && chmod 700 ~/build-script.sh
~~~

Now you can use it like with this command:

~~~
~/build-script.sh
~~~