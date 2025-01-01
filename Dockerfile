# Stage 1: PHP-Apache setup
FROM php:8.0-apache AS php-apache

# Enable mod_rewrite for Apache (useful for PHP projects)
RUN a2enmod rewrite

# Copy the entire project into the container
COPY . /var/www/html/

# Set permissions for the web server
RUN chown -R www-data:www-data /var/www/html/

# Expose port 80 for PHP-Apache
EXPOSE 80

# Set the directory index to index.php (or index.html)
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf

RUN echo "<Directory /var/www/html/>" >> /etc/apache2/apache2.conf
RUN echo "    AllowOverride All" >> /etc/apache2/apache2.conf
RUN echo "    Require all granted" >> /etc/apache2/apache2.conf
RUN echo "</Directory>" >> /etc/apache2/apache2.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Stage 2: Nginx setup
FROM nginx:latest

# Copy the project files into Nginx's serving directory
COPY . /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]

