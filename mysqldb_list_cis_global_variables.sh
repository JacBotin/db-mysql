# MYSQL - Lists mysql security configuration variables
#
now="$(date)"
printf "Current date and time %s\n" "$now"
#
# Access Parameters
#
#vhost="db-mysql.hostname"
vuser="root"
vdir=/home/jacqueline.botin/db-mysql
time mysql -h localhost -u $vuser -p$1 < /$vdir/mysqldb_list_cis_global_variables.sql >> /$vdir/diagnostic_cis_global_variables_mysqldb.txt
#
time mysql -h localhost -u $vuser -p$1 < /$vdir/mysqldb_list_cis_global_variables_nok.sql >> /$vdir/mysqldb_apply_set_cis_global_variables_nok.sql
