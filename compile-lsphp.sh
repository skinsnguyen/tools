#!/bin/bash
# Nam-Nguyen
# 27-03-2025
#https://www.php.net/manual/en/configure.about.php

# Exit on any error
#set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Function to install dependencies
install_dependencies() {
    echo "Updating package list and installing dependencies..."
    yum update -y
    yum groupinstall -y "Development Tools"
    yum install -y \
        libxml2-devel \
        libpng-devel \
        libjpeg-devel \
        libc-client-devel \
        libmcrypt-devel \
        libtidy \
        libtidy-devel \
        openssl-devel \
        curl-devel \
        libxslt-devel \
        freetype-devel \
        gmp-devel \
        mysql-devel \
        postgresql-devel \
        sqlite-devel \
        bzip2-devel \
        readline-devel \
        libicu-devel \
        oniguruma-devel \
        libsodium-devel \
        libzip-devel
}

# Function to build PHP
build_php() {
    local PHP_VERSION=$1
    local PREFIX="/usr/local/lsws/lsphp${PHP_VERSION//./}"
    local DOWNLOAD_URL="https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz"

    echo "Building PHP ${PHP_VERSION}..."

    # Download PHP source
    wget -O php-${PHP_VERSION}.tar.gz "${DOWNLOAD_URL}" || {
        echo "Failed to download PHP ${PHP_VERSION}"
        exit 1
    }

    # Extract source
    tar -xzf php-${PHP_VERSION}.tar.gz
    cd php-${PHP_VERSION}

    # Configure options (adjusted for version compatibility)
    CONFIG_OPTS=(
        "--prefix=${PREFIX}"
        "--with-libdir=lib64"
        "--with-config-file-path=${PREFIX}/etc"
        "--with-config-file-scan-dir=${PREFIX}/etc/php.d"
        "--with-zlib"
        "--with-gd"
        "--with-jpeg-dir"
        "--with-png-dir"
        "--with-freetype-dir"
        "--with-libxml-dir"
        "--with-curl"
        "--with-openssl"
        "--with-mysqli"
        "--with-pdo-mysql"
        "--with-pdo-sqlite"
        "--enable-mbstring"
        "--enable-bcmath"
        "--enable-zip"
        "--enable-ftp"
        "--enable-sockets"
        "--enable-soap"
        "--enable-shmop"
        "--enable-sysvsem"
        "--enable-sysvshm"
        "--enable-pcntl"
        "--enable-intl"
        "--with-bz2"
        "--with-gettext"
        "--with-litespeed"
    )

    # Version-specific adjustments
    if [[ "$PHP_VERSION" < "7.0" ]]; then
        CONFIG_OPTS+=("--with-mcrypt" "--with-mysql" "--enable-gd-native-ttf")
    fi
    if [[ "$PHP_VERSION" > "7.1" ]]; then
        CONFIG_OPTS+=("--with-sodium")
    fi
    if [[ "$PHP_VERSION" > "7.3" ]]; then
        CONFIG_OPTS+=("--with-freetype" "--with-jpeg" "--with-zip")
    else
        CONFIG_OPTS+=("--with-freetype-dir" "--with-jpeg-dir")
    fi

    # Configure
    echo "Configuring PHP ${PHP_VERSION}..."
    ./configure "${CONFIG_OPTS[@]}"

    # Compile and install
    echo "Compiling PHP ${PHP_VERSION}..."
    make -j$(nproc)
    echo "Installing PHP ${PHP_VERSION}..."
    make install

    # Create config directory and copy php.ini
    mkdir -p ${PREFIX}/etc/php.d
    cp php.ini-production ${PREFIX}/etc/php.ini

    # Clean up
    cd ..
    rm -rf php-${PHP_VERSION} php-${PHP_VERSION}.tar.gz

    echo "PHP ${PHP_VERSION} installed successfully to ${PREFIX}"
}

# Available PHP versions
PHP_VERSIONS=("5.6.36" "7.0.33" "7.3.33" "7.4.33" "8.0.30" "8.1.27" "8.2.17" "8.3.4" "8.4.0")

# Check if version is specified
if [ -z "$1" ]; then
    echo "Please specify a PHP version to build"
    echo "Available versions: ${PHP_VERSIONS[*]}"
    echo "Usage: $0 <version> [all]"
    exit 1
fi

# Install dependencies once
install_dependencies

# Build specified version(s)
if [ "$1" == "all" ]; then
    for version in "${PHP_VERSIONS[@]}"; do
        build_php "$version"
    done
else
    # Check if specified version is valid
    if [[ ! " ${PHP_VERSIONS[*]} " =~ " $1 " ]]; then
        echo "Invalid PHP version. Available versions: ${PHP_VERSIONS[*]}"
        exit 1
    fi
    build_php "$1"
fi

echo "Build process completed!"
