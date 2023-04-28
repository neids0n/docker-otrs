# 🛠️ docker-otrs 
Aplicação OTRS no docker

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
