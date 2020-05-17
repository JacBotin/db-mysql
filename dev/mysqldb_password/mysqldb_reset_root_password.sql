use mysql;
update user 
   set authentication_string=PASSWORD('$pwd'), 
       plugin="mysql_native_password"
where User='root';
flush privileges;
quit;