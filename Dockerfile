ARG RUBY_VERSION=3.1.4

FROM ruby:$RUBY_VERSION

# Set environment variables
ENV TZ=Asia/Tokyo

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libxslt1-dev \
    libxml2-utils \
    xsltproc \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install webrick gem
RUN gem install webrick

# Copy files
COPY . .
