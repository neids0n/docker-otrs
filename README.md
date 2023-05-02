# Project to deploy OTRS with docker

- OTRS is a modern and flexible ticket and process management system.

## Database Setup and Basic System Configuration

Please use the web installer at http://localhost/otrs/installer.pl (replace "localhost" with your OTRS hostname) to setup your database and basic system settings such as email accounts.
##

## **Note**: 
The following configuration settings are recommended for MySQL setups. Please add the following lines to /etc/my.cnf under the [mysqld] section:

- max_allowed_packet   = 64M
- query_cache_size     = 32M
- innodb_log_file_size = 256M
##               

## **Note**: 

Please note that OTRS requires utf8 as database storage encoding.
##

## First login

Now you are ready to login to your system at http://localhost/otrs/index.pl with the credentials you configured in the web installer (User: root@localhost).

With this step, the basic system setup is finished.
##

## Start the OTRS Daemon

The new OTRS daemon is responsible for handling any asynchronous and recurring tasks in OTRS. What has been in cron file definitions previously is now handled by the OTRS daemon, which is now required to operate OTRS. The daemon also handles all GenericAgent jobs and must be started from the otrs user.

``` 
shell> /opt/otrs/bin/otrs.Daemon.pl start 
```

##            

To schedule these cron jobs on your system, you can use the script Cron.sh with the otrs user.

```
shell> /opt/otrs/bin/Cron.sh start
```
            

Stopping the cron jobs is also possible (useful for maintenance):

```
shell> /opt/otrs/bin/Cron.sh stop
```

# 💡 How to use this image

##  Deploy OTRS
```
docker run --name mysql -e MYSQL_ROOT_PASSWORD=neids0n -e MYSQL_DATABASE=otrs -e MYSQL_USER=otrs -e MYSQL_PASSWORD=passwd -d mysql:debian
docker run --name otrs --link mysql:mysql -p 80:80 -d neids0n/otrs:6.0.36
```

## Deploy GLPI with database and persistence data

- First, create Mysql container with volume

```
docker run --name mysql -e MYSQL_ROOT_PASSWORD=neids0n -e MYSQL_DATABASE=otrs -e MYSQL_USER=otrs -e MYSQL_PASSWORD=passwd --volume otrs_dbdata:/var/lib/mysql -d mysql:debian 
```

- Then, create GLPI container with volume and link Mysql container

```
docker run --name otrs --link mysql:mysql -p 80:80 --volume otrs_data:/opt/otrs -d neids0n/otrs:6.0.36
```

## Deploy with docker-compose

To deploy with docker compose, you use docker-compose.yml and mysql.env file. You can modify mysql.env

- mysql.env
```
MYSQL_ROOT_PASSWORD=neids0n
MYSQL_DATABASE=otrs
MYSQL_USER=otrs
MYSQL_PASSWORD=passwd
```

- docker-compose.yaml
```
version: '2'
services:
  mysql:
    image: mysql:debian
    container_name: mysql-otrs
    hostname: mysql-otrs
    restart: always
    networks:
      - otrs_network
    env_file:
      - ./mysql.env
    volumes:
      - 'otrs_dbdata:/var/lib/mysql'

  otrs:
    image: neids0n/otrs:6.0.36
    container_name: otrs
    hostname: otrs
    restart: always
    networks:
      - otrs_network
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'otrs_data:/opt/otrs'
    depends_on:
      - mysql

volumes:
  otrs_dbdata:
    driver: local
  otrs_data:
    driver: local

networks:
  otrs_network:
    driver: bridge
```

To deploy, just run the following command on the same directory as files

```
docker-compose up -d
```

# Environnment variables

## TIMEZONE

If you need to set timezone for Apache and PHP

From commande line

```
docker run --name otrs --hostname otrs --link mysql:mysql --volume otrs_data:/opt/otrs -p 80:80 --env "TIMEZONE=America/Bahia" -d neids0n/otrs:6.0.36
```

## From docker-compose

Modify this settings

```
environment:
     TIMEZONE=America/Bahia
```
