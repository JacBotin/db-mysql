select user, host from mysql.user where File_priv = 'Y';/* update mysql.user set file_priv = 'N' where user = $user and host = $host;*/
select user, host from mysql.user where super_priv = 'Y';/* update mysql.user set file_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where shutdown_priv = 'Y';/* update mysql.user set shutdown_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where create_user_priv = 'Y';/* update mysql.user set create_user_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where grant_priv = 'Y';/* update mysql.user set grant_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
select user, host from mysql.user where repl_slave_priv = 'Y';/* update mysql.user set repl_slave_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/
SELECT USER, HOST FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root';/* UPDATE mysql.user SET Drop_priv = 'N' where user = $user and host = $host;*/
