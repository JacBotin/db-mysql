# MariaDb - Lists MariaDb security configuration variables
echo "Enter the Hostname:";
read hostname;
# Removes all files before creating them updated
rm -r results_audit_$hostname
#
echo "CREATING DIRECTORIES : results_audit_$hostname"
#
mkdir -p results_audit_$hostname
#
# Complete list with the current status of the cis audit variables.
mysql -h $hostname -u root -p < mariadb_cis_variables_audit_listing.sql | sed  's/\t/;/g' >> results_audit_$hostname/result_mariadb_cis_variables_audit_listing.csv
#
# Lists action on variables that do not comply with the CIS recommendation. Must be added to the my.cnf file.
mysql -h $hostname -u root -p < mariadb_cis_variables_audit_listing_nok_general.sql | sed  's/\t/;/g' >> results_audit_$hostname/result_mariadb_cis_variables_audit_change_general.csv
#
# Lists action on directories and files used by the database. Must have their permissions only for users of the mysql or mariadb database
mysql -h $hostname -u root -p < mariadb_cis_variables_audit_listing_nok_path.sql | sed  's/\t/;/g' >> results_audit_$hostname/result_mariadb_cis_variables_audit_change_path.csv
#
# Lists action on database users (other than root) who have super privileges. Only root user should have super privileges.
mysql -h $hostname -u root -p < mariadb_cis_variables_audit_listing_nok_userprivilegies.sql | sed  's/\t/;/g' >> results_audit_$hostname/result_mariadb_cis_variables_audit_change_userprivilegies.csv
