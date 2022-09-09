FROM php:7.4-fpm
RUN apt-get update && apt-get install -y zlib1g-dev libpng-dev curl libicu-dev libxml2-dev g++ libxslt-dev libzip-dev zip 

RUN docker-php-ext-install mysqli pdo pdo_mysql gettext zip gd intl xmlrpc soap opcache xsl\
    && docker-php-ext-enable mysqli pdo pdo_mysql gd intl xmlrpc soap opcache xsl

RUN apt-get -y install tzdata cron

RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    echo "Europe/Berlin" > /etc/timezone
    

#RUN apt-get -y remove tzdata
RUN rm -rf /var/cache/apk/*

# Copy cron file to the cron.d directory
COPY crontab /etc/cron.d/cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cron

# Apply cron job
RUN crontab /etc/cron.d/cron

# Create the log file to be able to run tail
RUN mkdir -p /var/log/cron


# Run the command on container startup
CMD cron && tail -f /var/log/cron/cron.log


