# Every command entered in the terminal is stored in an operating system history file. Therefore, it is recommended to update via database script as follows
# This script changes the root password of the mysql database when the password is set to root of the operating system
# It is recommended to define a secure character combination as the database root password.
# Connect to mysql in the terminal informing only the user root..

mysql -u root 

# If the mysql root password is associated with the server's root password it will connect without asking for a password
# If OK. Connected in.. {mysql/mariadb> }
# replace '$password' in the sql command below with the password chosen for the mysql user root

update mysql.user set authentication_string=password('$password'), 
            plugin='mysql_native_password' where User='root';
 
flush privileges;

exit