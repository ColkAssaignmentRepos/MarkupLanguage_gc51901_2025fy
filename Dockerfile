# Stage 1: Builder - 静的コンテンツの生成とビルドに必要な依存関係をインストール
FROM ubuntu:22.04 AS builder

ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    make \
    xsltproc \
    libxml2-dev \
    libxslt1-dev \
    libxml2-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY src ./src
COPY Makefile ./Makefile
COPY data0421.xml ./data0421.xml

# Makefileを実行して静的HTMLファイルを生成
# wwwディレクトリは /app/www に生成される
RUN make

# Stage 2: Runtime - 最終的な実行環境、最小限の依存関係のみ
FROM ubuntu:22.04

ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    ruby \
    && rm -rf /var/lib/apt/lists/*

# Apacheモジュールを有効化
RUN a2enmod cgi rewrite

COPY apache/httpd.conf /etc/apache2/sites-available/000-default.conf

COPY --from=builder /app/www /var/www/html

COPY --from=builder /app/src/cgi /var/www/html/cgi
RUN chmod +x /var/www/html/cgi/*.rb
RUN chown -R www-data:www-data /var/www/html/cgi

COPY --from=builder /app/src /var/www/html/src
COPY --from=builder /app/data0421.xml /var/www/html/data0421.xml
RUN chmod +x /var/www/html/cgi/*.rb

RUN chown -R www-data:www-data /var/www/html
RUN chown -R www-data:www-data /var/www/html/cgi

# Apacheをフォアグラウンドで起動
CMD ["apache2ctl", "-D", "FOREGROUND"]
