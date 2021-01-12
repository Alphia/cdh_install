#! /usr/bin/env bash

set -euxo pipefail

su -l postgres -c "psql -f ./setup_db_name_and_owner.sql"
/opt/cloudera/cm/schema/scm_prepare_database.sh postgresql scm scm 1qaz2ws

