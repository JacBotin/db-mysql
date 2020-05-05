-- 1 - necessary stop mysql
-- sudo service mysql stop
--
-- 2 - start mode safe mysql
-- sudo mysqld_safe --skip-grant-tables 
-- 
-- obs: If an error occurs in the previous command, it is necessary to create the socket directory then necessary
-- sudo mkdir -p /var/run/mysqld
-- sudo chown mysql:mysql /var/run/mysqld
-- 
-- 3 - access mysql with user root without password 
-- mysql -u root
-- 
use mysql;
update user 
   set authentication_string=PASSWORD('$pwd'), 
       plugin="mysql_native_password"
where User='root';
flush privileges;
quit;

-- 4 - Stop service mysqld_safe
-- sudo mysqladmin shutdown
-- OR
-- ps -ef | grep mysql
-- sudo kill -9 [process id resulting from the previous command]

-- 5 - Start mysql normally
-- sudo service mysql start