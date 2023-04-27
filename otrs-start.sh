#!/bin/bash

# Criar o usuário OTRS e adicioná-lo ao grupo www-data
useradd -d /opt/otrs -c 'OTRS user' otrs
usermod -G www-data otrs

# Configurando o Cron para os usuarios OTRS
cd /opt/otrs/var/cron
for foo in *.dist; do cp $foo `basename $foo .dist`; done
/opt/otrs/bin/Cron.sh start

# Configurando o Apache
sed -i '$s/$/\n/' /etc/apache2/apache2.conf && sed -i '$i ServerName localhost' /etc/apache2/apache2.conf
ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/sites-enabled/zzz_otrs.conf
a2enmod perl && a2enmod deflate && a2enmod filter && a2enmod headers && service apache2 restart && service apache2 stop

# Colocando o serviço do apache em primeiro plano
/usr/sbin/apache2ctl -D FOREGROUND