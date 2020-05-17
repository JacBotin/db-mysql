set global datadir = {new directory different from the system};
set global log_bin_basename = {new location different from the /var or /usr or root 
SET GLOBAL slow_query_log_file = {new_location};
SET GLOBAL relay_log_basename = {new_location};
SET GLOBAL general_log_file = {new_location};
set global local_infile = 'OFF';
select user, host from mysql.user where File_priv = 'Y';/* update mysql.user set file_priv = 'N' where user = $user and host = $host;*/
select user, host from mysql.user where super_priv = 'Y';/* update mysql.user set file_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where shutdown_priv = 'Y';/* update mysql.user set shutdown_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where create_user_priv = 'Y';/* update mysql.user set create_user_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where grant_priv = 'Y';/* update mysql.user set grant_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where repl_slave_priv = 'Y';/* update mysql.user set repl_slave_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where authentication_string='';/* UPDATE mysql.user SET plugin = 'mysql_native_password', authentication_string = PASSWORD('$pwd') where user = $user and host = $host;*/
SELECT USER, HOST FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root';/* UPDATE mysql.user SET Drop_priv = 'N' where user = $user and host = $host;*/
INSTALL PLUGIN validate_password SONAME 'validate_password.so'; /* Run script mysqldb_alter_validate_password.sql*/
SET GLOBAL default_password_lifetime=90;
INSTALL PLUGIN audit_log SONAME 'audit_log.so'; /* Run script mysqldb_alter_audit_log.sql */
STOP SLAVE; CHANGE MASTER TO MASTER_SSL_VERIFY_SERVER_CERT=1; START SLAVE;
