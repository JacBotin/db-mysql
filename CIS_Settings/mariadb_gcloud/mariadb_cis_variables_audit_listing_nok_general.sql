select concat("gcloud sql instances patch $INSTANCE_NAME --user=root --database-flags ", group_concat(action_cmd))
from
(
SELECT case @@global.log_warnings 
            when null then 'NOK - log_warnings is not defined'
            when 0 then 'NOK - log_warnings 0 enables logging of error messages.Equivalent log_error_verbosity = 1'
            when 1 then 'OK - log_warnings 1 enables logging of error and warning messages. Equivalent log_error_verbosity = 2'
            else 'OK - log_warnings 2 enables logging of error, warning and note messages. Equivalent log_error_verbosity = 3'
       end as diagnostic,
       case when (@@global.log_warnings is null or @@global.log_warnings = 0)
            then 'log_warnings=1'
            else 'no action needed'
       end as action_cmd  
union 
select case when @@global.slow_query_log = 0 
	        then 'OK - slow_query_log is disable'
	        else 'NOK - slow_query_log is enable. Verify need and check directory and access control configured in the variable slow_query_log_file and long_query_time'
	        end as diagnostic,
	   case when @@global.slow_query_log = 0 
	        then 'no action needed'
	        else 'slow_query_log = 0'
	   end as action_cmd   
union	   
select CASE WHEN @@global.general_log = 0
	        THEN 'OK - general_log is disable (0=OFF, 1=ON)'
	        else 'OK_NOK - general_log is enable. Check access control directory and file defined in general_log_file variable' 
	   end as diagnostic,
	   CASE WHEN @@global.general_log = 0
	        THEN 'no action needed' 
	        ELSE 'general_log = ''OFF'''
       END AS action_cmd   
union            
select CASE WHEN @@global.local_infile = 0
	        THEN 'OK - local_infile is disable'
	        else 'NOK - local_infile is enable. Check directory and access control configured in the variable secure_file_priv ' 
	   end as diagnostic,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE 'local_infile = ''OFF''' 
            END AS action_cmd  
union 
SELECT CASE WHEN @@session.sql_mode LIKE '%NO_AUTO_CREATE_USER%' 
            then 'OK -  no_auto_create_user is set in sql_mode' 
            else 'NOK - no_auto_create_user is NOT set in sql_mode' 
       END diagnostic,
       CASE WHEN @@session.sql_mode not LIKE '%NO_AUTO_CREATE_USER%' 
            then (select CONCAT("sql_mode = ", @@global.sql_mode , ",NO_AUTO_CREATE_USER"))
            else 'no action needed' 
       end as action_cmd
union                     
select CASE WHEN @@global.old_passwords = 0
	        THEN 'OK - 0 the authenticate with the mysql_native_password. Recommended.'
	        else 'NOK - different of 0 - this authentication method uses a vulnerable algorithm hash' 
	   end as diagnostic,
	   CASE WHEN @@global.old_passwords = 0
	        THEN 'no action needed'
	        ELSE 'old_passwords = 0'
            END AS action_cmd  
union 
select CASE WHEN @@global.secure_auth = 1
	        THEN 'OK - 1 is ON - The server blocks passwords in old formats'
	        else 'NOK - different of 1 OFF - The server does not block passwords in old formats' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'no action needed'
	        ELSE 'secure_auth = 1'
            END AS action_cmd  
union 
select CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'OK - Secure Sockets Layer is enable'
	        else 'NOK - Secure Sockets Layer is disable. All network traffic must use SSL/TLS when traveling over untrusted networks' 
	   end as diagnostic,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'no action needed'
	        ELSE 'have_ssl = ''YES'''
            END AS action_cmd) t
where substring(diagnostic, 1, 3) = 'NOK';