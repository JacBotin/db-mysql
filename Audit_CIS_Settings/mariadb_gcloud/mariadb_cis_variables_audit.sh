# MariaDb - Lists MariaDb security configuration variables
#
now="$(date)"
printf "Current date and time %s\n" "$now"
#
echo "Enter the Hostname:";
read hostname;
echo "Enter the Root Password (password not shown):"
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
# Removes all files before creating them updated
rm -r results_audit
echo "CREATING DIRECTORIES : RESULTS_AUDIT"
mkdir -p results_audit

mysql -h $hostname -u root -p$password < mariadb_cis_variables_audit_listing.sql >> results_audit/result_mariadb_cis_variables_audit_listing.txt
#
mysql -h $hostname -sN -u root -p$password < mariadb_cis_variables_audit_listing_nok_general.sql >> results_audit/result_mariadb_cis_variables_audit_change_general.sql
#
mysql -h $hostname -sN -u root -p$password < mariadb_cis_variables_audit_listing_nok_path.sql >> results_audit/result_mariadb_cis_variables_audit_change_path.sql
#
mysql -h $hostname -sN -u root -p$password < mariadb_cis_variables_audit_listing_nok_userprivilegies.sql >> results_audit/result_mariadb_cis_variables_audit_change_userprivilegies.sql
