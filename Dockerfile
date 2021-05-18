FROM ubuntu:18.04

VOLUME ["/var/moodledata"]
EXPOSE 80 443

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt -qq -o=Dpkg::Use-Pty=0 update && \
    apt install -y zip unzip curl procps software-properties-common ca-certificates apt-transport-https lsb-release gnupg wget supervisor mcrypt git-core git && \
    add-apt-repository ppa:ubuntu-toolchain-r/ppa -y && \
    add-apt-repository ppa:ondrej/php -y

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt -qq -o=Dpkg::Use-Pty=0 update && \
	apt install -y nginx mysql-client pwgen python-setuptools php7.4 \
		php7.4-gd php7.4-fpm php7.4-cli libcurl4 \
		libcurl3-dev php7.4-curl php7.4-xmlrpc php7.4-intl php7.4-common \
        php7.4-mysql php7.4-bcmath php7.4-bz2 php7.4-json php7.4-redis php-pear php7.4-dev php7.4-xml php7.4-mbstring php7.4-zip php7.4-soap cron php7.4-ldap && \
	cd /tmp && \
	git clone https://github.com/plunix/iomad.git --depth=1 && \
	mv /tmp/iomad/* /var/www/html/ && \
	rm /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html

ADD moodle-config-mariadb.php /var/www/html/config.php

# Database info and other connection information derrived from env variables. See readme.
# Set ENV Variables externally Moodle_URL should be overridden.
ENV MOODLE_URL http://127.0.0.1

# Enable when using external SSL reverse proxy
# Default: false
ENV SSL_PROXY false

