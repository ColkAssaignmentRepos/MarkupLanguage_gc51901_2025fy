FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    make \
    apache2 \
    ruby \
    ruby-digest \
    xsltproc \
    libxml2-dev \
    libxslt1-dev \
    libxml2-utils \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Apacheモジュールを有効化
RUN a2enmod cgi rewrite

COPY apache/httpd.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /app

COPY src ./src
COPY Makefile ./Makefile
COPY data0421.xml ./data0421.xml

RUN chmod +x ./src/script/generate_author_hashes.sh ./src/script/generate_author_pages.sh

ARG BASE_URL
ARG CGI_BASE_URL

RUN make all BASE_URL=${BASE_URL} CGI_BASE_URL=${CGI_BASE_URL}

RUN cp -r ./www/. /var/www/html/
RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

RUN mkdir -p /usr/lib/cgi-bin
RUN cp -r ./src/cgi/. /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*.rb
RUN chown -R www-data:www-data /usr/lib/cgi-bin

# Apacheをフォアグラウンドで起動
CMD ["apache2ctl", "-D", "FOREGROUND"]
