# MYSQL - Lists mysql security configuration variables
#
now="$(date)"
printf "Current date and time %s\n" "$now"
#
echo "Enter the Mysql Hostname:";
read hostname;
echo "Enter the Mysql root password (password not shown):"
unset password;
while IFS= read -r -s -n1 pass; do
  if [[ -z $pass ]]; then
     echo
     break
  else
     echo -n '*'
     password+=$pass
  fi
done
echo "CREATING DIRECTORIES : RESULTS"
mkdir -p results_audit

mysql -h $hostname -u root -p$password < mysqldb_cis_variables_audit_listing.sql >> results_audit/result_mysqldb_cis_variables_audit_listing.txt
#
mysql -h $hostname -sN -u root -p$password < mysqldb_cis_variables_audit_listing_nok.sql >> results_audit/result_mysqldb_cis_variables_audit_change.sql