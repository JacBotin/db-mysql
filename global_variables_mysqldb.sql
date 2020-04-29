SELECT 'log_error_verbosity' as name_variable, 
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
       'OK_NOK - Check location and access control' as diagnostic,
       'set global datadir = {new directory different from the system};' as action_cmd
union
select 'log_bin_basename' as name_variable,
       @@global.log_bin_basename as value_variable,
       'OK_NOK - Check location and access control' as diagnostic,
       'set global log_bin_basename = {new location different from the /var or /usr or root ' as action_cmd      
union       
select 'slow_query_log' as name_variable,
	   @@global.slow_query_log as value_variable,
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
	   'OK_NOK - Check directory and access control configured in the variable slow_query_log_file' as diagnostic,
	   'SET GLOBAL slow_query_log_file = {new_location};' as action_cmd      
union
select 'relay_log_basename' as name_variable,
	   @@global.relay_log_basename as value_variable,
	   'OK_NOK - Check directory and access control configured in the variable relay_log_basename' as diagnostic,
	   'SET GLOBAL relay_log_basename = {new_location};' as action_cmd
union 	   
select 'general_log' as name_variable,
	   @@global.general_log as value_variable,
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
	   'OK_NOK - Check directory and access control configured in the variable general_log_file' as diagnostic,
	   'SET GLOBAL general_log_file = {new_location};' as action_cmd
union 	   
select 'local_infile' as name_variable,
	   @@global.local_infile as value_variable,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'OK - local_infile is disable'
	        else 'NOK - local_infile is enable. Check directory and access control configured in the variable secure_file_priv ' 
	   end as diagnostic,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE CONCAT("set global local_infile = ","'OFF';")
            END AS action_cmd  
union             
select 'secure_file_priv' as name_variable,
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
select 'have_ssl' as name_variable,
	   @@global.have_ssl as value_variable,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'OK - Secure Sockets Layer is enable'
	        else 'NOK - Secure Sockets Layer is disable. All network traffic must use SSL/TLS when traveling over untrusted networks' 
	   end as diagnostic,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'no action needed'
	        ELSE CONCAT("set global have_ssl = ", "'YES';")
            END AS action_cmd  
union             
select 'old_passwords' as name_variable,
	   @@global.old_passwords as value_variable,
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
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'OK - 1 is ON - The server blocks passwords in old formats'
	        else 'NOK - different of 1 OFF - The server does not block passwords in old formats' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'no action needed'
	        ELSE 'set global secure_auth = 1;'
            END AS action_cmd ;