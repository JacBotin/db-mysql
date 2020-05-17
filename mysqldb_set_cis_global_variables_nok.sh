# MYSQL - Lists mysql security configuration variables
#
now="$(date)"
printf "Current date and time %s\n" "$now"
#
time mysql -u root -p < mysqldb_set_cis_global_variables_nok.sql