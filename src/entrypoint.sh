#!/bin/sh -e

: "${DB_NAME:=racktables}"
: "${DB_HOST:=mariadb}"
: "${DB_USER:=racktables}"

SECRET="/opt/racktables/wwwroot/inc/secret.php"
if [ ! -e ${SECRET} ]; then
  case "${USR_AUTH_SRC}" in
    # saml, database, ldap, httpd
    "database")  
      cat > ${SECRET} <<EOF
<?php
# DATABASE
\$pdo_dsn = 'mysql:host=${DB_HOST};dbname=${DB_NAME}';
\$db_username = '${DB_USER}';
\$db_password = '${DB_PASS}';
# AUTH
\$user_auth_src = 'database';
\$require_local_account = TRUE;
# See https://wiki.racktables.org/index.php/RackTablesAdminGuide
?>
EOF
    ;;
    "ldap")
    cat > ${SECRET} <<EOF
<?php
# DATABASE
\$pdo_dsn = 'mysql:host=${DB_HOST};dbname=${DB_NAME}';
\$db_username = '${DB_USER}';
\$db_password = '${DB_PASS}';
# AUTH
\$user_auth_src = 'ldap';
\$require_local_account = FALSE;
\$LDAP_options = array
(
    'server' => '${LDAP_HOSTS}',
    'domain' => '${LDAP_DOMAIN}',
    'search_attr' => 'sAMAccountName',
    'search_dn' => '${LDAP_SDN}',
    'displayname_attrs' => 'givenname sn',
    'options' => array (LDAP_OPT_PROTOCOL_VERSION => 3, LDAP_OPT_REFERRALS => 0),
    'search_bind_rdn' => '${LDAP_USER}',
    'search_bind_password' => '${LDAP_PASS}',
    'group_attr' => '${LDAP_GATTR}',
    'group_filter' => '${LDAP_GFILTER}'
);
# See https://wiki.racktables.org/index.php/RackTablesAdminGuide
?>
EOF
    ;;
  esac
fi

chmod 0400 /opt/racktables/wwwroot/inc/secret.php
chown nobody:nogroup /opt/racktables/wwwroot/inc/secret.php

echo 'To initialize the db, first go to /?module=installer&step=5'

exec "$@"
