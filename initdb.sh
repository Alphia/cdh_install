#! /usr/bin/env bash

set -euxo pipefail

cp setup_db_name_and_owner.sql /var/lib/pgsql/setup_db_name_and_owner.sql
chmod 744 /var/lib/pgsql/setup_db_name_and_owner.sql
su -l postgres -c "psql -f setup_db_name_and_owner.sql"
sed -i -e "s/^host.*127.0.0.1.32.*/host 	all     	all     	0.0.0.0\/0       	md5/g" /var/lib/pgsql/data/pg_hba.conf
systemctl restart postgresql
/opt/cloudera/cm/schema/scm_prepare_database.sh postgresql scm scm 1qaz2ws

