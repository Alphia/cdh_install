#! /usr/bin/env bash

set -euxo pipefail

su -l postgres -c "psql -f /var/lib/pgsql/config_db.sql"
/opt/cloudera/cm/schema/scm_prepare_database.sh postgresql scm scm 1qaz2ws

