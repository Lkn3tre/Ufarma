FROM php:8.1-apache

# Install dependencies for SQL Server PHP extensions
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev gnupg2 libgssapi-krb5-2 libicu-dev g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Microsoft ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/$(. /etc/os-release; echo $VERSION_ID)/prod.list \
    | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y \
    msodbcsql17 mssql-tools && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Install PHP extensions for SQL Server
RUN pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy custom php.ini
COPY php.ini /usr/local/etc/php/

# Set working directory
WORKDIR /var/www/html

# Copy application source
COPY ../src/ /var/www/html
