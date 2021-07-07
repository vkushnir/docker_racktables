# vim: set ft=dockerfile:

ARG BUILD_FROM="alpine:3.13"

FROM ${BUILD_FROM}

ARG RACKTABLES_TAG="RackTables-0.21.5"
# Author with no obligation to maintain
LABEL author="Paul Tötterman <paul.totterman@iki.fi>"
LABEL author="Vladimir Kushnir <vkushnir@gmail.com>"

ENV DB_HOST="mariadb" \
    DB_NAME="racktables" \
    DB_USER="racktables" \
    DB_PASS="" \
    LDAP_USER="" \
    LDAP_PASS="" \
    LDAP_HOSTS="" \
    LDAP_DOMAIN="" \
    LDAP_SDN="" \
    LDAP_GATTR="memberOf" \
    LDAP_GFILTER="/^[Cc][Nn]=([^,]+)/" \
    USR_AUTH_SRC="database"

COPY entrypoint.sh /entrypoint.sh
COPY ${RACKTABLES_TAG}.tar.gz racktables_contribs.tar.gz /
RUN apk --no-cache add \
    ca-certificates \
    curl \
    php7-bcmath \
    php7-curl \
    php7-fpm \
    php7-gd \
    php7-json \
    php7-ldap \
    php7-mbstring \
    php7-pcntl \
    php7-pdo_mysql \
    php7-session \
    php7-snmp \
    && chmod +x "/entrypoint.sh" \
#    && curl -sSLo "/${RACKTABLES_TAG}.tar.gz" "https://github.com/RackTables/racktables/archive/${RACKTABLES_TAG}.tar.gz" \
#    && curl -sSLo "/racktables_contribs.tar.gz" "https://github.com/RackTables/racktables-contribs/archive/master.tar.gz" \
    && tar -xz -C /opt -f "/${RACKTABLES_TAG}.tar.gz" \
    && tar -xz -C /opt -f "/racktables_contribs.tar.gz" "racktables-contribs-master/snmpgeneric.php" \
    && mv "/opt/${RACKTABLES_TAG}" "/opt/racktables" \
    && mv "/opt/racktables-contribs-master/snmpgeneric.php" "/opt/racktables/plugins/" \
    && rm -f "/${RACKTABLES_TAG}.tar.gz" \
    && rm -f "/racktables_contribs.tar.gz" && rmdir "/opt/racktables-contribs-master" \
    && sed -i -e "s|^listen =.*$|listen = 9000|" "/etc/php7/php-fpm.d/www.conf" \
    && sed -i -e "s|^;daemonize = .*|daemonize = no|" "/etc/php7/php-fpm.conf"

VOLUME "/opt/racktables/wwwroot"
EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7"]
