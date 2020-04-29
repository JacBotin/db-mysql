# MYSQL - Lists mysql security configuration variables
#
now="$(date)"
printf "Current date and time %s\n" "$now"
#
# Access Parameters
#
#vhost="db-mysql.hostname"
vuser="root"
time mysql -h localhost -u $vuser -p$1 -tee ~/home/db-mysql/security_global_variables_mysql.log < /home/db-mysql/resume_cis_global_variables_mysqldb.sql

