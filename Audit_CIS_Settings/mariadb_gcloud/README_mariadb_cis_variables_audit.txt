Guidance for auditing Oracle CIS standards in instances of mySQL / MariaDb databases on the Google Cloud platform.

Run shell script mariaadb_cis_variables_audit.sh:

The following information is requested during execution:
– $hostname = database instance hostname
– $password =root password (necessary root user who has privileges to modify the instance configuration).
       
This shell script executes four (4) * .sql scripts and generates another four (4) resulting files:
    1. Generates the file with the list of all audit variables:
       mariadb_cis_variables_audit_listing.sql → result_mariadb_cis_variables_audit_listing.txt 
    2. Generates the file with necessary actions for ‘General’ variables that are nonstandard
	   mariadb_cis_variables_audit_listing_nok_general.sql → result_mariadb_cis_variables_audit_change_general.sh
    3. Generates the file with necessary actions of variables that contain directories and / or file names used by the database instance
       mariadb_cis_variables_audit_listing_nok_path.sql → results_audit/result_mariadb_cis_variables_audit_change_path.sh  
    4. Generates the file with necessary actions to analyze and / or modify privileges of common database users
       mariadb_cis_variables_audit_listing_nok_userprivilegies.sql → results_audit/result_mariadb_cis_variables_audit_change_userprivilegies.sql


After performing all the procedures, it is necessary to restart the instance to apply the modifications:

Shell script gcloud_restart_instance.sh


References: 
http://www.itsecure.hu/library/image/CIS_Oracle_MySQL_Community_Server_5.7_Benchmark_v1.0.0.pdf
https://mariadb.com/kb/en/system-variable-differences-between-mariadb-102-and-mysql-57/
https://cloud.google.com/sql/docs/mysql/flags#gcloud_1
