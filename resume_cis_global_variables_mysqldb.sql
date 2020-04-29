SELECT 'log_error_verbosity' as name_variable,
	   'The log_error_verbosity system variable provides additional information to the MySQL log. A value of 1 enables logging of error messages. A value of 2 enables logging of error and warning messages, and a value of 3 enables logging of error, warning and note messages.' as description_variable,
       @@global.log_error_verbosity as value_variable,
       case @@global.log_error_verbosity 
            when null then 'NOK - log_error_verbosity is not defined'
            when 1 then 'OK - log_error_verbosity 1 enables logging of error messages'
            when 2 then 'OK - log_error_verbosity 2 enables logging of error and warning messages'
            else 'OK - log_error_verbosity 3 enables logging of error, warning and note messages'
       end as diagnostic,
       case when @@global.log_error_verbosity is null 
            then 'SET GLOBAL log_error_verbosity=1;'
            else 'no action needed'
       end as action_cmd     
union
SELECT 'sql_mode' as name_variable, 
	   'NO_AUTO_CREATE_USER is an option for sql_mode that prevents a GRANT statement from automatically creating a user when authentication information is not provide.' as description_variable,
       @@global.sql_mode as value_variable, 
       CASE WHEN @@session.sql_mode LIKE '%NO_AUTO_CREATE_USER%' 
            then 'OK -  no_auto_create_user is set in sql_mode' 
            else 'NOK - no_auto_create_user is NOT set in sql_mode' 
       END diagnostic,
       CASE WHEN @@session.sql_mode not LIKE '%NO_AUTO_CREATE_USER%' 
            then (select CONCAT("SET GLOBAL sql_mode = ", @@global.sql_mode , ",NO_AUTO_CREATE_USER"))
            else 'no action needed' 
       end as action_cmd
union        
select 'log_error' as name_variable,
       @@global.log_error as value_variable,
       '' as description_variable,
       case when @@global.log_error = 'stderr'
            then 'NOK - log_error is writes the error log to the console'
            else 'OK - log_error is writes the erros log to the file defined'
       end diagnostic,
       case when @@global.log_error = 'stderr'
            then 'SET GLOBAL log_error= .\$name_file.err;'
            else 'no action needed'
       end as action_cmd  
union  
select 'data_dir' as name_variable,
       @@global.datadir as value_variable,
        '' as description_variable,
       'OK_NOK - Check location and access control' as diagnostic,
       'set global datadir = {new directory different from the system};' as action_cmd
union
select 'log_bin_basename' as name_variable,
       @@global.log_bin_basename as value_variable,
       '' as description_variable,
       'OK_NOK - Check location and access control' as diagnostic,
       'set global log_bin_basename = {new location different from the /var or /usr or root ' as action_cmd      
union       
select 'slow_query_log' as name_variable,
	   @@global.slow_query_log as value_variable,
	   '' as description_variable,
	   case when @@global.slow_query_log = 0 
	        then 'OK - slow_query_log is disable'
	        else 'NOK - slow_query_log is enable. Verify need and check directory and access control configured in the variable slow_query_log_file'
	        end as diagnostic,
	   case when @@global.slow_query_log = 0 
	        then 'no action needed'
	        else 'SET GLOBAL slow_query_log = 0;'
	   end as action_cmd   
union	   
select 'slow_query_log_file' as name_variable,
	   @@global.slow_query_log_file as value_variable,
	   '' as description_variable,
	   'OK_NOK - Check directory and access control configured in the variable slow_query_log_file' as diagnostic,
	   'SET GLOBAL slow_query_log_file = {new_location};' as action_cmd      
union
select 'relay_log_basename' as name_variable,
	   @@global.relay_log_basename as value_variable,
	   '' as description_variable,
	   'OK_NOK - Check directory and access control configured in the variable relay_log_basename' as diagnostic,
	   'SET GLOBAL relay_log_basename = {new_location};' as action_cmd
union 	   
select 'general_log' as name_variable,
	   @@global.general_log as value_variable,
	   '' as description_variable,
	   CASE WHEN @@global.general_log = 0
	        THEN 'OK - general_log is disable (0=OFF, 1=ON)'
	        else 'NOK - general_log is enable. Check access control directory and file defined in general_log_file variable' 
	   end as diagnostic,
	   CASE WHEN @@global.general_log = 0
	        THEN 'no action needed'
	        ELSE CONCAT("set global general_log = ","'OFF';")
            END AS action_cmd      
union            
select 'general_log_file' as name_variable,
	   @@global.general_log_file as value_variable,
	   '' as description_variable,
	   'OK_NOK - Check directory and access control configured in the variable general_log_file' as diagnostic,
	   'SET GLOBAL general_log_file = {new_location};' as action_cmd
union 	   
select 'local_infile' as name_variable,
	   @@global.local_infile as value_variable,
	   '' as description_variable,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'OK - local_infile is disable'
	        else 'NOK - local_infile is enable. Check directory and access control configured in the variable secure_file_priv ' 
	   end as diagnostic,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE CONCAT("set global local_infile = ","'OFF';")
            END AS action_cmd  
union 
SELECT 'daemon_memcached' as name_variable,
       (select PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'daemon_memcached') as value_variable,
       'The InnoDB memcached Plugin allows users to access data stored in InnoDB with the memcached protocol. By default the plugin doesnt do authentication, which means that anyone with access to the TCP/IP port of the plugin can access and modify the data.' as description_variable,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'daemon_memcached' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'NOK - The InnoDB memcached Plugin is active. He is vulnerable.'
            else 'OK - The InnoDB memcached Plugin is not installed'
       end as diagnostic,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'daemon_memcached' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'uninstall plugin daemon_memcached;'
            else 'no action needed'
       end as action_cmd  
union 
select 'secure_file_priv' as name_variable,
	   @@global.secure_file_priv as value_variable,
	   '' as description_variable,
	   CASE WHEN @@global.secure_file_priv = ''
	        THEN 'NOK - No secure directories are set for uploading files'
	        else 'OK - Just check the directory access control ' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_file_priv = '' and @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE 'set global secure_file_priv = {secure directory};'
            END AS action_cmd  
union             
select 'have_ssl' as name_variable,
	   @@global.have_ssl as value_variable,
	   '' as description_variable,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'OK - Secure Sockets Layer is enable'
	        else 'NOK - Secure Sockets Layer is disable. All network traffic must use SSL/TLS when traveling over untrusted networks' 
	   end as diagnostic,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'no action needed'
	        ELSE CONCAT("set global have_ssl = ", "'YES';")
            END AS action_cmd  
union  
SELECT 'ssl_type' as name_variable,  
       ''  as value_variable,
       'All network traffic must use SSL / TLS when traveling over untrusted networks. SSL / TLS must be enforced per user for users entering the system through the net' as description_variable, 
       case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then 'NOK - There are users without any specific SSL certificate.'
            else 'OK - All business users have an SSL certificate set'
       end as diagnostic,
       case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then concat("select user, host, ssl_type FROM mysql.user WHERE NOT HOST IN (","'::1,'", "'127.0.0.1',","'localhost');", "-", "GRANT USAGE ON *.* TO ", "'user'@'host' REQUIRE SSL;'")
            else 'no action needed'
       end as action_cmd     
union 
select 'old_passwords' as name_variable,
	   @@global.old_passwords as value_variable,
	   '' as description_variable,
	   CASE WHEN @@global.old_passwords = 0
	        THEN 'OK - 0 the authenticate with the mysql_native_password. Recommended.'
	        else 'NOK - different of 0 - this authentication method uses a vulnerable algorithm hash' 
	   end as diagnostic,
	   CASE WHEN @@global.old_passwords = 0
	        THEN 'no action needed'
	        ELSE 'set global old_passwords = 0;'
            END AS action_cmd  
union 
select 'secure_auth' as name_variable,
	   @@global.secure_auth as value_variable,
	   '' as description_variable,
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'OK - 1 is ON - The server blocks passwords in old formats'
	        else 'NOK - different of 1 OFF - The server does not block passwords in old formats' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'no action needed'
	        ELSE 'set global secure_auth = 1;'
            END AS action_cmd  
union 
SELECT 'validade_password' as name_variable,
       PLUGIN_STATUS as value_variable,
       '' as description_variable,
       case when PLUGIN_STATUS = 'ACTIVE'
            then 'OK - Policies security password is active'
            else 'NOK - Policies security password is not installed'
       end as diagnostic,
       case when PLUGIN_STATUS = 'ACTIVE'
            then 'no action needed'
            else concat("INSTALL PLUGIN validate_password SONAME ","'validate_password.so';")
       end as action_cmd     
FROM INFORMATION_SCHEMA.PLUGINS 
WHERE PLUGIN_NAME = 'validate_password'
union
select 'validate_password_policy' as name_variable,
	   @@global.validate_password_policy as value_variable,
	  'The validate_password_policy value can be specified using numeric values 0, 1, 2, or the corresponding symbolic values LOW, MEDIUM, STRONG. The following table describes the tests performed for each policy. 0-LOW - Check only the length, 1-MEDIUM - Check length, numeric, lowercase / uppercase and special characters. 2-STRONG - Check length, numeric, lowercase / uppercase and special characters, dictionary file' as description_variable,	   
	   CASE WHEN @@global.validate_password_policy = 'MEDIUM'
	        THEN 'OK - Control minimum of criteria of requirement for user password is defined'
	        else 'NOK - Control of minimum number of special characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_policy = 'MEDIUM'
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_policy = MEDIUM;'
            END AS action_cmd  
union 
select 'validate_password_length' as name_variable,
	   @@global.validate_password_length as value_variable,
	  'This variable control the minimum number of characters that validate_password requires passwords to have' as description_variable,	   
	   CASE WHEN @@global.validate_password_length >= 14
	        THEN 'OK - The minimum number of characters that validate_password is defined 14 characters'
	        else 'NOK - The minimum number of characters that validate_password is NOT defined or is defined with less of 14 characters' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_length >= 14
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_length = 14;'
            END AS action_cmd  
union 
select 'validate_password_check_user_name' as name_variable,
	   @@global.validate_password_check_user_name as value_variable,
	  'This variable controls user name matching. Compares passwords to the user name part of the effective user account for the current session and rejects them if they match' as description_variable,	   
	   CASE WHEN @@global.validate_password_check_user_name = 1
	        THEN 'OK - Control to prevent the password from being the same as the users name is enabled'
	        else 'NOK - Control to prevent the password from being the same as the users name is disabled' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_check_user_name = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_check_user_name = ON;'
            END AS action_cmd  
union             
select 'validate_password_mixed_case_count' as name_variable,
	   @@global.validate_password_mixed_case_count as value_variable,
	  'The minimum number of lowercase and uppercase characters that validate_password requires passwords to have if the password policy is MEDIUM or stronger.' as description_variable,	   
	   CASE WHEN @@global.validate_password_mixed_case_count = 1
	        THEN 'OK - Control of minimum number of lowercase and uppercase characters requirement for user password is defined'
	        else 'NOK - Control of minimum number of lowercase and uppercase characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_mixed_case_count = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_mixed_case_count = 1;'
            END AS action_cmd  
union             
select 'validate_password_number_count' as name_variable,
	   @@global.validate_password_number_count as value_variable,
	  'The minimum number of numbers characters that validate_password requires passwords to have if the password policy is MEDIUM or stronger.' as description_variable,	   
	   CASE WHEN @@global.validate_password_number_count = 1
	        THEN 'OK - Control of minimum number of numbers characters requirement for user password is defined'
	        else 'NOK - Control of minimum number of numbers characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_number_count = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_number_count = 1;'
            END AS action_cmd  
union             
select 'validate_password_special_char_count' as name_variable,
	   @@global.validate_password_special_char_count as value_variable,
	  'The minimum number of specials characters that validate_password requires passwords to have if the password policy is MEDIUM or stronger.' as description_variable,	   
	   CASE WHEN @@global.validate_password_special_char_count = 1
	        THEN 'OK - Control of minimum number of special characters requirement for user password is defined'
	        else 'NOK - Control of minimum number of special characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_special_char_count = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_special_char_count = 1;'
            END AS action_cmd  
union             
select 'default_password_lifetime' as name_variable,
	   @@global.default_password_lifetime as value_variable,
	  'Password expiry for specific users provides user passwords with a unique time bounded lifetime.' as description_variable,	   
	   CASE WHEN @@global.default_password_lifetime >= 90
	        THEN 'OK - Control of requires password change every 90 days is defined'
	        else 'NOK - Control of requires password change every 90 days is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.default_password_lifetime >= 90
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL default_password_lifetime=90;'
            END AS action_cmd 
union             
select 'MASTER_SSL_VERIFY_SERVER_CERT' as name_variable,
       (select ssl_verify_server_cert  from mysql.slave_master_info) AS value_variable,
       'In the MySQL slave context the setting MASTER_SSL_VERIFY_SERVER_CERT indicates whether the slave should verify the masters certificate. This configuration item may be set to Yes or No, and unless SSL has been enabled on the slave the value will be ignored.' as description_variable,
       case when (select ssl_verify_server_cert  from mysql.slave_master_info) = 1
            then 'OK - Use of SSL certificate for authentication between master / slave is defined'
	        else 'NOK - Use of SSL certificate for authentication between master / slave is NOT defined' 
	   end as diagnostic,
	   CASE WHEN (select ssl_verify_server_cert  from mysql.slave_master_info) = 1
	        THEN 'no action needed'
	        ELSE 'STOP SLAVE; CHANGE MASTER TO MASTER_SSL_VERIFY_SERVER_CERT=1; START SLAVE;'
            END AS action_cmd 