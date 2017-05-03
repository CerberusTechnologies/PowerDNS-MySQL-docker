FROM debian:jessie
MAINTAINER Derek Vance <dvance@cerb-tech.com>

ENV SQL_HOST=localhost
ENV SQL_PORT=3306
ENV SQL_DB=pdns
ENV SQL_USER=root
ENV SQL_PASS=changeme
ENV SQL_DNSSEC=no


RUN apt-get update && apt-get -y install wget

RUN echo "deb http://repo.powerdns.com/debian jessie-auth-40 main" > /etc/apt/sources.list.d/pdns.list

RUN echo "Package: pdns-*" >> /etc/apt/preferences.d/pdns && \
    echo "Pin: origin repo.powerdns.com" >> /etc/apt/preferences.d/pdns && \
    echo "Pin-Priority: 600" >> /etc/apt/preferences.d/pdns

RUN wget https://repo.powerdns.com/FD380FBB-pub.asc && \
    apt-key add FD380FBB-pub.asc && \
    rm FD380FBB-pub.asc

RUN apt-get update && \
    apt-get -y install pdns-server pdns-backend-mysql mysql-client

RUN rm /etc/powerdns/pdns.d/* && \
    echo "launch=gmysql" >> /etc/powerdns/pdns.conf && \
    echo "gmysql-host=$SQL_HOST" >> /etc/powerdns/pdns.conf && \
    echo "gmysql-port=$SQL_PORT" >> /etc/powerdns/pdns.conf && \
    echo "gmysql-dbname=$SQL_DB" >> /etc/powerdns/pdns.conf && \
    echo "gmysql-user=$SQL_USER" >> /etc/powerdns/pdns.conf && \
    echo "gmysql-password=$SQL_USER" >> /etc/powerdns/pdns.conf && \
    echo "gmysql-dnssec=$SQL_DNSSEC" >> /etc/powerdns/pdns.conf
	
COPY check_db.sh /tmp/
COPY schema.sql /tmp/

RUN chmod +x /tmp/check_db.sh
RUN /tmp/check_db.sh $SQL_HOST $SQL_PORT $SQL_USER $SQL_PASS $SQL_DB
		
RUN cat /etc/powerdns/pdns.conf
	

EXPOSE 53/tcp 53/udp 53000/tcp 8081/tcp

ENTRYPOINT ["/usr/sbin/pdns_server", "--daemon=no"]