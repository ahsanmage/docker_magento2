FROM ubuntu:16.04
LABEL maintainer="Ahsan Mohiuddin <mr.developer09@gmail.com>"
LABEL description="Docker Image for Magento 2.2 with Nginx Redis"

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Update base image
# Add sources for latest nginx
# Install software requirements
#
ENV ERRORS=0
ENV IMAGE_PHP_VERSION=7.1

# Install System Dependencies

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	software-properties-common \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libfreetype6-dev \
	libicu-dev \
  libssl-dev \
	apt-utils \
	gnupg \
	redis-tools \
#	mysql-client \
	git \
	vim \
	wget \
	curl \
	lynx \
	psmisc \
	unzip \
	tar \
	cron \
	bash-completion \
	&& apt-get clean
    
RUN apt-get update && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    apt-get install -y software-properties-common && \
    nginx=stable && \
    add-apt-repository ppa:nginx/$nginx && \
    LANG=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install supervisor \
        nginx-extras \
        php${IMAGE_PHP_VERSION}-fpm \
        git \
        php${IMAGE_PHP_VERSION}-mysql \
        php-apcu \
        php${IMAGE_PHP_VERSION}-curl \
        php${IMAGE_PHP_VERSION}-gd \
        php${IMAGE_PHP_VERSION}-intl \
        php${IMAGE_PHP_VERSION}-mcrypt \
        php${IMAGE_PHP_VERSION}-memcache \
        php${IMAGE_PHP_VERSION}-sqlite \
        php${IMAGE_PHP_VERSION}-tidy \
        php${IMAGE_PHP_VERSION}-xmlrpc \
        php${IMAGE_PHP_VERSION}-xsl \
        php${IMAGE_PHP_VERSION}-pgsql \
        php${IMAGE_PHP_VERSION}-mongo \
        php${IMAGE_PHP_VERSION}-ldap \
        pwgen \
        php${IMAGE_PHP_VERSION}-cli \
        curl && \
    apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    update-alternatives --set php /usr/bin/php${IMAGE_PHP_VERSION} && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir /opt/lua && \
    git clone https://github.com/knyar/nginx-lua-prometheus.git /tmp/lua-prom && \
    cp /tmp/lua-prom/prometheus.lua /opt/lua/ && \
    nginx -v

# tweak nginx config
RUN sed -i -e"s/worker_processes  1/worker_processes auto/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

# tweak php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf

# fix ownership of sock file for php-fpm
RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf && \
    find /etc/php/${IMAGE_PHP_VERSION}/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \; && \
    mkdir /run/php


RUN phpenmod mcrypt && \
    rm -Rf /etc/nginx/conf.d/* && \
    mkdir -p /etc/nginx/ssl/ && \
    rm -f /etc/nginx/sites-enabled/default && \
    #ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default && \
    #ln -s /etc/nginx/sites-available/metrics.conf /etc/nginx/sites-enabled/metrics && \
    #chmod 755 /cmd.sh && \
    chown -Rf www-data.www-data /usr/share/nginx/html/
    
# Copy our nginx config
#RUN rm -Rf /etc/nginx/nginx.conf
#ADD conf/nginx.conf /etc/nginx/nginx.conf

# Install Magento Dependencies

RUN apt-get update \
    && apt-get install -y \
  	php${IMAGE_PHP_VERSION}-opcache \
  	php${IMAGE_PHP_VERSION}-gd \
  	php${IMAGE_PHP_VERSION}-bcmath \
  	php${IMAGE_PHP_VERSION}-intl \
  	php${IMAGE_PHP_VERSION}-mbstring \
  	php${IMAGE_PHP_VERSION}-mcrypt \
  	php${IMAGE_PHP_VERSION}-soap \
  	php${IMAGE_PHP_VERSION}-xsl \
  	php${IMAGE_PHP_VERSION}-zip

# Install oAuth

RUN apt-get update \
  	&& apt-get install -y \
    gcc make autoconf libc-dev pkg-config \
  	libpcre3 \
  	libpcre3-dev 
  	# php-pear \
  #	&& pecl${IMAGE_PHP_VERSION}- install oauth \
  #	&& echo "extension=oauth.so" > /etc/php${IMAGE_PHP_VERSION}-sp/conf.d/oauth.ini

# Install Node, NVM, NPM and Grunt

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
  	&& apt-get install -y nodejs build-essential \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh \
    && npm install \
    && npm install -g gulp && npm install -g grunt \
    && npm i -g grunt-cli yarn

# Install Composer

RUN	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
RUN composer global require hirak/prestissimo

# Install Code Sniffer

#RUN git clone https://github.com/magento/marketplace-eqp.git ~/.composer/vendor/magento/marketplace-eqp
#RUN cd ~/.composer/vendor/magento/marketplace-eqp && composer install
#RUN ln -s ~/.composer/vendor/magento/marketplace-eqp/vendor/bin/phpcs /usr/local/bin;

##Install Varnish

#RUN apt-get update \
##install supervisor and setup supervisord.conf file
#&& mkdir -p /var/log/supervisor \
##install varnish
#&& apt-get -y install varnish \
#&& rm /etc/varnish/default.vcl \
#&& rm /etc/default/varnish 

ENV PATH="/var/www/.composer/vendor/bin/:${PATH}"

RUN apt-get update \
    && apt-get install nano \ 
    sudo

# Configuring system

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
mkdir -p /etc/nginx/sites-enabled/ && \
mkdir -p /etc/nginx/ssl/ && \
rm -Rf /var/www/* && \
mkdir /var/www/html/

RUN chown -Rf www-data.www-data /var/www/html/
RUN chmod 777 -Rf /var/www /var/www/.*

ADD .docker/config/magento.conf /etc/nginx/sites-available/default
ADD .docker/config/nginx.magento.conf /etc/nginx/nginx.magento.conf
ADD .docker/config/magento2ce.conf /etc/nginx/sites-available/magento2ce
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/magento2ce /etc/nginx/sites-enabled/magento2ce

ADD .docker/config/php.ini /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini
COPY .docker/bin/* /usr/local/bin/
COPY .docker/users/* /var/www/
#COPY .docker/cache_server/default.vcl /etc/varnish/default.vcl
#COPY .docker/cache_server/varnish /etc/default/varnish
COPY .docker/config/supervisord.conf /etc/supervisord.conf
COPY .docker/users/cmd.sh /
#COPY info.php /var/www/html/info.php

RUN chmod +x /usr/local/bin/*
#RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf


RUN chmod 777 -Rf /var/www /var/www/.*
#	&& a2enmod rewrite \
#	&& a2enmod headers

#Database Work
#RUN cp ./sqldump/usedatabase.sql /docker-entrypoint-initdb.d

EXPOSE 80 5022 9022 6082 33022 1022

VOLUME /var/www/html
WORKDIR /var/www/html

# Add cron job
ADD .docker/config/crontab /etc/cron.d/magento2-cron
RUN chmod 0644 /etc/cron.d/magento2-cron 

CMD ["/bin/bash", "/cmd.sh"]
