FROM ubuntu/apache2:latest

LABEL maintainer="neids0n"

# Atualizar o repositório e instalar os pacotes necessários
RUN apt update && \
apt install -y \
vim \
cron \
perl \
make \
systemd \
libdigest-perl-md5-perl \
libapache2-mod-perl2 \
libarchive-zip-perl \
libcrypt-eksblowfish-perl \
libcss-minifier-xs-perl \
libdatetime-perl \
libdbi-perl \
libdbd-mysql-perl \
libdbd-odbc-perl \
libdbd-pg-perl \
libencode-hanextra-perl \
libjson-xs-perl \
libjavascript-minifier-xs-perl \
libmail-imapclient-perl \
libauthen-ntlm-perl \
libmoo-perl \
libnet-dns-perl \
libnet-ldap-perl \
libtemplate-perl \
libtext-csv-xs-perl \
libxml-libxml-perl \
libxml-libxslt-perl \
libxml-parser-perl \
libyaml-libyaml-perl

# Copiar OTRS
COPY ./otrs /opt/otrs

# Copiar e executar o script de instalação
COPY otrs-start.sh /opt/
RUN chmod +x /opt/otrs-start.sh
ENTRYPOINT ["/opt/otrs-start.sh"]

# Exposição das portas
EXPOSE 80 443