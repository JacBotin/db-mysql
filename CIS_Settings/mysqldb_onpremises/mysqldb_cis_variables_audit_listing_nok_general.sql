select action_cmd
from
(
SELECT case @@global.log_error_verbosity 
            when null then 'NOK - log_error_verbosity is not defined'
            when 1 then 'OK - log_error_verbosity 1 enables logging of error messages'
            when 2 then 'OK - log_error_verbosity 2 enables logging of error and warning messages'
            else 'OK - log_error_verbosity 3 enables logging of error, warning and note messages'
       end as diagnostic,
       case when @@global.log_error_verbosity = 1 
            then 'SET GLOBAL log_error_verbosity=2;'
            else 'no action needed'
       end as action_cmd  	   
union 
select case when @@global.slow_query_log = 0 
	        then 'OK - slow_query_log is disable'
	        else 'NOK - slow_query_log is enable. Verify need and check directory and access control configured in the variable slow_query_log_file and long_query_time'
	        end as diagnostic,
	   case when @@global.slow_query_log = 0 
	        then 'no action needed'
	        else 'SET GLOBAL slow_query_log = 0;'
	   end as action_cmd   
union	   
select CASE WHEN @@global.general_log = 0
	        THEN 'NOK - general_log is disable (0=OFF, 1=ON)'
	        else 'OK_NOK - general_log is enable. Check access control directory and file defined in general_log_file variable' 
	   end as diagnostic,
	   CASE WHEN @@global.general_log = 0
	        THEN CONCAT("set global general_log = ","'ON';")
	        ELSE 'Check access control directory and file defined in general_log_file variable'
       END AS action_cmd       
union            
select CASE WHEN @@global.local_infile = 0
	        THEN 'OK - local_infile is disable'
	        else 'NOK - local_infile is enable. Check directory and access control configured in the variable secure_file_priv ' 
	   end as diagnostic,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE 'set global local_infile = ''OFF'';' 
            END AS action_cmd  
union 
SELECT CASE WHEN @@session.sql_mode LIKE '%NO_AUTO_CREATE_USER%' 
            then 'OK -  no_auto_create_user is set in sql_mode' 
            else 'NOK - no_auto_create_user is NOT set in sql_mode' 
       END diagnostic,
       CASE WHEN @@session.sql_mode not LIKE '%NO_AUTO_CREATE_USER%' 
            then (select CONCAT("SET GLOBAL sql_mode = ", @@global.sql_mode , ",NO_AUTO_CREATE_USER"))
            else 'no action needed' 
       end as action_cmd
union                     
select CASE WHEN @@global.old_passwords = 0
	        THEN 'OK - 0 the authenticate with the mysql_native_password. Recommended.'
	        else 'NOK - different of 0 - this authentication method uses a vulnerable algorithm hash' 
	   end as diagnostic,
	   CASE WHEN @@global.old_passwords = 0
	        THEN 'no action needed'
	        ELSE 'set global old_passwords = 0;'
            END AS action_cmd  
union 
select CASE WHEN @@global.secure_auth = 1
	        THEN 'OK - 1 is ON - The server blocks passwords in old formats'
	        else 'NOK - different of 1 OFF - The server does not block passwords in old formats' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'no action needed'
	        ELSE 'set global secure_auth = 1;'
            END AS action_cmd  
union 
select CASE WHEN @@global.default_password_lifetime >= 90
	        THEN 'OK - Control of requires password change every 90 days is defined'
	        else 'NOK - Control of requires password change every 90 days is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.default_password_lifetime >= 90
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL default_password_lifetime=90;'
            END AS action_cmd 
union 
select CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'OK - Secure Sockets Layer is enable'
	        else 'NOK - Secure Sockets Layer is disable. All network traffic must use SSL/TLS when traveling over untrusted networks' 
	   end as diagnostic,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'no action needed'
	        ELSE 'set global have_ssl = ''YES'';'
            END AS action_cmd
union			
select case when @@global.master_info_repository = 'TABLE'
            then 'OK - The configuration is set to TABLE. Recommended safe way. '
	        else 'NOK - The configuration is not set for TABLE. FILE is not the recommended safe way.' 
	   end as diagnostic,
	   CASE WHEN @@global.master_info_repository = 'TABLE'
	        THEN 'no action needed'
	        ELSE 'set global master_info_repository = ''TABLE'';'
            END AS action_cmd) t
where substring(diagnostic, 1, 3) = 'NOK';