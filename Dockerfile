FROM ubuntu:22.04

ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    ruby \
    ruby-dev \
    libxml2-dev \
    libxslt1-dev \
    libxml2-utils \
    xsltproc \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod cgi rewrite

COPY apache/httpd.conf /etc/apache2/sites-available/000-default.conf

COPY src/cgi /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin/*.rb

COPY www /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD ["apache2ctl", "-D", "FOREGROUND"]
