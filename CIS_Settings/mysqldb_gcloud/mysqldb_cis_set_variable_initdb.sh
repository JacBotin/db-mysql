
echo "Enter mysql root password (password not shown)";
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
echo "CREATING DIRECTORY : RESULTS"
mkdir -p results_init

echo "CIS MYSQLDB Audit Started";

echo "Time and Date" >> results_init/result_mysqldb_cis_set_variable_initdb.txt
echo 'select NOW()'| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

echo "SHOW VARIABLES LIKE '%version%';"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

-- 'The log_error_verbosity system variable provides additional information to the MySQL log. A value of 1 enables logging of error messages. A value of 2 enables logging of error and warning messages, and a value of 3 enables logging of error, warning and note messages.' as description_variable,
echo "SET GLOBAL log_error_verbosity=1;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

--'NO_AUTO_CREATE_USER is an option for sql_mode that prevents a GRANT statement from automatically creating a user when authentication information is not provide.' as description_variable,
echo "SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';"| mysql -u root -p$password >> result_mysqldb_cis_set_variable_initdb.txt

--'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
echo "SET GLOBAL slow_query_log = 0;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

--'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
echo "set global general_log = 'ON';"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

-- 'The local_infile parameter dictates whether files located on the MySQL clients computer can be loaded or selected via LOAD DATA INFILE or SELECT local_file' as description_variable,
echo "SET GLOBAL local_infile = 'OFF';" | mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

--'All network traffic must use SSL/TLS when traveling over untrusted networks.' as description_variable,
echo "SET GLOBAL have_ssl = 'YES';" | mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

--'The purpose of the old_passwords system variable is to permit backward compatibility with pre-4.1 clients under circumstances where the server would otherwise generate long password hashes' as description_variable,
echo "SET GLOBAL old_passwords = 0;" | mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

-- 'If this variable is enabled, the server blocks connections by clients that attempt to use accounts that have passwords stored in the old (pre-4.1) format. Enable this variable to prevent all use of passwords employing the old format (and hence insecure communication over the network).' as description_variable,
echo "SET GLOBAL secure_auth = 1;" | mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt

-- 'Password complexity includes password characteristics such as length, case, length, and character sets. This recommendation prevents users from choosing weak passwords which can easily be guessed. ' as description_variable,
echo "INSTALL PLUGIN validate_password SONAME ,'validate_password.so';" | mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

-- Enables control to prevent the password from being the same as the user's name 
echo "SET GLOBAL validate_password_check_user_name = ON;" | mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

-- requires a minimum of 14 digits as the password value
echo "SET GLOBAL validate_password_length = 14;" | mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

-- requires a minimum of Uppercase characters in the password value
echo "SET GLOBAL validate_password_mixed_case_count = 1;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

-- requires a minimum of numeric characters in the password value
echo "SET GLOBAL validate_password_number_count = 1;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

-- requires a minimum of special characters in the password value
echo "SET GLOBAL validate_password_special_char_count=1;"| mysql -u root -p$password >> result_mysqldb_cis_set_variable_initdb.txt 

-- Password policy criteria
-- 0 - LOW - validates only length (size)
-- 1 - MEDIUM - Length; numeric, lowercase / uppercase, and special characters
-- 2 - STRONG - Length; numeric, lowercase / uppercase and special characters; dictionary file
echo "SET GLOBAL validate_password_policy = MEDIUM;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

-- 'Password expiry for specific users provides user passwords with a unique time bounded lifetime.' as description_variable,	   
echo "SET GLOBAL default_password_lifetime=90;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

echo "INSTALL PLUGIN audit_log SONAME ,'audit_log.so';"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

echo "set global audit_log_connection_policy = ALL;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

echo "SET GLOBAL audit_log_exclude_accounts = NULL;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

echo "SET GLOBAL audit_log_include_accounts = NULL;"| mysql -u root -p$password >>results_init/result_mysqldb_cis_set_variable_initdb.txt 

echo "SET GLOBAL audit_log_policy = ALL;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

echo "SET GLOBAL audit_log_statement_policy = ALL;"| mysql -u root -p$password >> results_init/result_mysqldb_cis_set_variable_initdb.txt 

echo "Enter the name of the user mysql who wants to change the password:";
read username;

select 'slow_query_log_file' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes. These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.slow_query_log_file as value_variable,
	   'OK_NOK - Check directory and access control configured in the variable slow_query_log_file. ' as diagnostic,
	   'SET GLOBAL slow_query_log_file = {new_location};' as action_cmd      
union
select 'relay_log_basename' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.relay_log_basename as value_variable,
	   'OK_NOK - Check directory and access control configured in the variable relay_log_basename' as diagnostic,
	   'SET GLOBAL relay_log_basename = {new_location};' as action_cmd
union 	   


union            
select 'general_log_file' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.general_log_file as value_variable,
	   'OK_NOK - Check directory and access control configured in the variable general_log_file' as diagnostic,
	   'SET GLOBAL general_log_file = {new_location};' as action_cmd
union 	   


union 
select 'secure_file_priv' as name_variable,
	   'The secure_file_priv option restricts to paths used by LOAD DATA INFILE or SELECT local_file. It is recommended that this option be set to a file system location that contains only resources expected to be loaded by MySQL' as description_variable,
	   @@global.secure_file_priv as value_variable,
	   CASE WHEN @@global.secure_file_priv = ''
	        THEN 'NOK - No secure directories are set for uploading files'
	        else 'OK - Just check the directory access control ' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_file_priv = '' and @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE 'set global secure_file_priv = {secure directory};'
            END AS action_cmd  
union 


union  
SELECT 'ssl_type' as name_variable,  
       'All network traffic must use SSL / TLS when traveling over untrusted networks. SSL / TLS must be enforced per user for users entering the system through the net' as description_variable, 
       ''  as value_variable,
       case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then 'NOK - There are users without any specific SSL certificate.'
            else 'OK - All business users have an SSL certificate set'
       end as diagnostic,
       case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then concat("select user, host, ssl_type FROM mysql.user WHERE NOT HOST IN (","'::1,'", "'127.0.0.1',","'localhost');", "/* RUN */", "GRANT USAGE ON *.* TO ", "'user'@'host' REQUIRE SSL;'")
            else 'no action needed'
       end as action_cmd     
union 

union             
select 'MASTER_SSL_VERIFY_SERVER_CERT' as name_variable,
       'In the MySQL slave context the setting MASTER_SSL_VERIFY_SERVER_CERT indicates whether the slave should verify the masters certificate. This configuration item may be set to Yes or No, and unless SSL has been enabled on the slave the value will be ignored.' as description_variable,
       (select ssl_verify_server_cert  from mysql.slave_master_info) AS value_variable,
       case when (select ssl_verify_server_cert  from mysql.slave_master_info) = 1
            then 'OK - Use of SSL certificate for authentication between master / slave is defined'
	        else 'NOK - Use of SSL certificate for authentication between master / slave is NOT defined' 
	   end as diagnostic,
	   CASE WHEN (select ssl_verify_server_cert  from mysql.slave_master_info) = 1
	        THEN 'no action needed'
	        ELSE 'STOP SLAVE; CHANGE MASTER TO MASTER_SSL_VERIFY_SERVER_CERT=1; START SLAVE;'
            END AS action_cmd ;