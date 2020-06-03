select action_sql_check, action_sql_change
from
(
SELECT case when (select count(1) from mysql.user where File_priv = 'Y' and User <> 'root') = 0
            then 'OK - The File_priv privilege is not enabled for common users'
            else 'NOK - The File_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where File_priv = 'Y' and User <> 'root') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where File_priv = ''Y'' and User <> ''root'''
	   end as action_sql_check,
       case when (select count(1) from mysql.user where File_priv = 'Y' and User <> 'root') = 0
            then 'no action needed'
            else 'update mysql.user set file_priv = ''N'' where user = $user and host = $host'
	   end as action_sql_change
union 
SELECT case when (select count(1) from mysql.user where Super_priv = 'Y' and user <> 'root') = 0
            then 'OK - The super_priv privilege is not enabled for common users'
            else 'NOK - The super_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where Super_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where super_priv = ''Y'' and User <> ''root''' 
	   end as action_sql_check,
	   case when (select count(1) from mysql.user where Super_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'update mysql.user set Super_priv = ''N'', plugin = ''mysql_native_password'' where user = $user and host = $host'  
       end as action_sql_change 
union             
SELECT case when (select count(1) from mysql.user where shutdown_priv = 'Y' and user <> 'root') = 0
            then 'OK - The shutdown privilege is not enabled for common users'
            else 'NOK - The shutdown privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where shutdown_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where shutdown_priv = ''Y'' and User <> ''root'''
	   end as action_sql_check,
	   case when (select count(1) from mysql.user where shutdown_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'update mysql.user set shutdown_priv = ''N'', plugin = ''mysql_native_password'' where user = $user and host = $host'  
       end as action_sql_change 
union             
SELECT case when (select count(1) from mysql.user where create_user_priv = 'Y' and user <> 'root') = 0
            then 'OK - The create_user_priv privilege is not enabled for common users'
            else 'NOK - The create_user_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where create_user_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where create_user_priv = ''Y'' and User <> ''root'''
	   end as action_sql_check,
	   case when (select count(1) from mysql.user where create_user_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'update mysql.user set create_user_priv = ''N'', plugin = ''mysql_native_password'' where user = $user and host = $host'  
       end as action_sql_change
union             
SELECT case when (select count(1) from mysql.user where grant_priv = 'Y' and user <> 'root') = 0
            then 'OK - The create_user_priv privilege is not enabled for common users'
            else 'NOK - The create_user_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where grant_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where grant_priv = ''Y'' and User <> ''root'''
	   end as action_sql_check,
       case when (select count(1) from mysql.user where grant_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'update mysql.user set grant_priv = ''N'', plugin = ''mysql_native_password'' where user = $user and host = $host'  
       end as action_sql_change 
union             
SELECT case when (select count(1) from mysql.user where repl_slave_priv = 'Y' and user <> 'root') = 0
            then 'OK - The repl_slave_priv privilege is not enabled for common users'
            else 'NOK - The repl_slave_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where repl_slave_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where repl_slave_priv = ''Y'' and User <> ''root'''
	   end as action_sql_check,
	   case when (select count(1) from mysql.user where repl_slave_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else 'update mysql.user set repl_slave_priv = ''N'', plugin = ''mysql_native_password'' where user = $user and host = $host'  
       end as action_sql_change
union
SELECT case when (SELECT count(1) FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root') = 0
            then 'OK - There are not users commons have all privileges'
            else 'NOK - There are users commons have all privileges. Check.'
       end as diagnostic,
       case when (SELECT count(1) FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root') = 0
            then 'no action needed'
            else 'SELECT USER, HOST FROM mysql.user WHERE ((Select_priv = ''Y'') OR (Insert_priv = ''Y'') OR (Update_priv = ''Y'') OR (Delete_priv = ''Y'') OR (Create_priv = ''Y'') OR (Drop_priv = ''Y'')) and user <> ''root'''
	   end as action_sql_check,
       case when (SELECT count(1) FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root') = 0
            then 'no action needed'
            else 'UPDATE mysql.user SET Drop_priv = ''N'' where user = $user and host = $host'  
       end as action_sql_change
union	   
SELECT case when (SELECT COUNT(1) FROM mysql.user WHERE authentication_string='') = 0
            then 'OK - No user has no password set'
            else 'NOK - There are users with no password set. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE authentication_string='') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where authentication_string='''
	   end as action_sql_check,
	   case when (SELECT COUNT(1) FROM mysql.user WHERE authentication_string='') = 0
            then 'no action needed'
            else 'UPDATE mysql.user SET plugin = ''mysql_native_password'', authentication_string = PASSWORD(''$pwd'') where user = $user and host = $host'  
       end as action_sql_change 
union             
SELECT case when (SELECT COUNT(1) FROM mysql.user WHERE plugin <> 'mysql_native_password') = 0
            then 'OK - All users are using the recommended password policy mysql_native_password'
            else 'NOK - There are users who are not using the recommended password policy mysql_native_password. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE plugin <> 'mysql_native_password') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where plugin <> ''mysql_native_password'''
	   end as action_sql_check,
	   case when (SELECT COUNT(1) FROM mysql.user WHERE plugin <> 'mysql_native_password') = 0
            then 'no action needed'
            else 'UPDATE mysql.user SET plugin = ''mysql_native_password'' where user = $user and host = $host'  
       end as action_sql_change 
union             
SELECT case when (SELECT COUNT(1) FROM mysql.user WHERE user = '') = 0
            then 'OK - No user is configured with anonymous usernames'
            else 'NOK - There are users with anonymous usernames configuration. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE user = '') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where user = '''
	   end as action_sql_check,
	   case when (SELECT COUNT(1) FROM mysql.user WHERE user = '') = 0
            then 'no action needed'
            else 'DELETE mysql.user where user = '' and host = $host'
       end as action_sql_change 
union 
SELECT case when (SELECT COUNT(1) FROM mysql.user WHERE host = '%') = 0
            then 'OK - No user is configured with wildcard hostname'
            else 'NOK - There are users with wildcard hostname configuration. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE host = '%') = 0
            then 'no action needed'
            else 'select user, host from mysql.user where host = ''%'''
	   end as action_sql_check,
	   case when (SELECT COUNT(1) FROM mysql.user WHERE host = '%') = 0
            then 'no action needed'
            else 'UPDATE mysql.user SET host = $host where user = $user and host = ''%'''  
       end as action_sql_change 
union
SELECT case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then 'NOK - There are users without any specific SSL certificate.'
            else 'OK - All business users have an SSL certificate set'
       end as diagnostic,
       case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then concat("select user, host, ssl_type FROM mysql.user WHERE NOT HOST IN (","'::1,'", "'127.0.0.1',","'localhost')")
            else 'no action needed'
       end as action_sql_check,
	   case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then 'GRANT USAGE ON *.* TO ''$user''@''$host'' REQUIRE SSL'
            else 'no action needed'
       end as action_sql_change 
	   ) T
where substring(diagnostic, 1, 3) = 'NOK';	   
