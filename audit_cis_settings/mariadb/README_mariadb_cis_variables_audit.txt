Guidance for auditing Oracle CIS standards in instances of MySQL / MariaDb databases

This procedure is performed under the Google Cloud Platform platform, but the scripts use standard features of mysql or mariadb database installations in linux environments.  
From the command line terminal, access the server via gcloud ssh (consider VPN or another valid access layer for external access previously running): 

user@machine:~$ gcloud beta compute ssh --zone "$zone" "$instance_name" --project "$project"

This operation requires administrative privileges to perform, so:

root@instance_name:/# sudo su

root Password 

The first step is to assign a password to the database root user. It is not recommended to use the operating system root user password.
Since every command entered in the terminal is stored in an operating system history file, it is recommended to perform this procedure directly in the database.
Connect to mysql in the terminal informing only the user root without password:

root@instance_name:/# mysql -u root 

If an error occurs in the command above stating that it requires the password, everything is fine and we can now go to the audit of the cis variables described below
If the mysql root password is associated with the operating system's root password, the connection will be made and we need to update the password as follows (This script changes the root password of the mysql or mariadb database.It is recommended to define a secure character combination as the database root password):
Replace '$ password' in the sql command below with the password chosen for the mysql root user:

MariaDB [(none)]> use mysql;
MariaDB [mysql]> update user set authentication_string=password('$password'),    plugin='mysql_native_password' where User='root'; 
MariaDB [mysql]>Flush privileges;
MariaDB [mysql]>exit

Note: Only users with administrative privileges can execute this command.


Audit database cis variables 

Copying scripts from the local directory to the gcloud instance by scp...

gcloud --project "$project" compute scp --recurse ~/db-mysql/audit_cis_settings/ user@instance_name:~ --zone "$zone"

Access the server via gcloud ssh, (VPN access or another access layer that is in effect for external access required): 

gcloud beta compute ssh --zone "$zone" "$instance_name" --project "$project"

This operation requires administrative privileges to perform, so:

sudo su

For standard MySQL installation, use the scripts in the audit_cis_settings / mysqldb directory and for installation MariaDb database, use the scripts in the audit_cis_settings / mariadb directory. 
In the database version directory, in our Mariadb example, the file   mariadb_cis_variables.sh is the script to be executed and to make it executable:

/audit_cis_settings/mariadb$ chmod a+x /.mariadb_cis_variables_audit.sh

And to execute:
 
/audit_cis_settings/mariadb$ /.mariadb_cis_variables_audit.sh

You will be asked to enter the parameters:
$instance_name (SQL Instance Name).
$password (root password. Necessary root user who has privileges to modify the instance configuration).
        
        This shell script executes four (4) * .sql scripts and generates another four (4) output *.csv files in a created directory called /results_audit_$instance_name.

Copying the generated files to a local directory:

gcloud --project "$project" compute scp --recurse user@instance_name:audit_cis_settings/mariadb/results_audit_localhost/  /home/user/audit_cis_settings/mariadb/results_audit_localhost/ --zone "us-east1-b" 
Understanding the output files:

1. Generates the file with the list of all audit variables:
Input: mariadb_cis_variables_audit_listing.sql
Output : result_mariadb_cis_variables_audit_listing.csv 

This file lists the grouped / classified CIS variables indicating the situation in accordance with the recommended standards. 
Here is an example of the contents of the list:

version_database
10.1.38-MariaDB-0ubuntu0.18.04.1
cis_category
Auditing and Logging
name_variable
log_warnings
description_variable
The log_warnings system variable provides additional information to the MySQL log
value_variable
2
diagnostic
OK
descritption_diagnostic
OK - log_warnings 2 enables logging of error, warning and note messages. Equivalent log_error_verbosity = 3
action
no action needed

2. Generates the file with necessary actions for ‘General’ variables that are nonstandard:
Input: mariadb_cis_variables_audit_listing_nok_general.sql
Output: result_mariadb_cis_variables_audit_change_general.csv

The commands contained in this output file must be configured in the database configuration file, usually called my.cnf.
Example of the contents of the output file:

action_mycnf
have_ssl = 'YES'
local_infile = 0 





3. Generates the file with necessary actions of variables that contain directories and / or file names used by the database instance:
Input: mariadb_cis_variables_audit_listing_nok_path.sql 
Output: result_mariadb_cis_variables_audit_change_path.csv  

This file lists directories and files unique to the database and should be accessed only by the database administrator user. In standard installations, it usually follows the standard operating system's directory hierarchy, such as / var / lib / mysql or / etc / mysql or var / log / mysql, for example. It is recommended that the database installation be on a different partition than the operating system whenever possible. Even when installed in the default directories, it is possible to ensure that only the database user has access to these files and directories, and this output file displays the command to follow this recommendation in the action_cmd_change_owner column.
Example of the contents of the output file:

name_variable
datadir
value_variable
/var/lib/mysql/
action_mycnf
datadir = '/$path/datafiles/data'
action_cmd_permission
chmod 700 /var/lib/mysql/
action_cmd_change_owner
chown mysql:mysql /var/lib/mysql/


The commands contained in this output file must also be configured in the database configuration file, usually called my.cnf.  

To edit the mysql database configuration file (my.cnf) usually found on standard installations in/etc/mysql:

root@instance_name:/# sudo nano /etc/mysql/my.cnf
 
After inserting and / or modifying the cis variables with the recommendations mentioned in the output files mentioned in items 2 and 3 above, Ctrl-O to save, Ctrl-X to exit.







4. Generates the file with necessary actions to analyze and/or modify privileges of common database users:
Input: mariadb_cis_variables_audit_listing_nok_userprivilegies.sql
Output: result_mariadb_cis_variables_audit_change_userprivilegies.csv
Example of the contents of the output file:

action_sql_check
select user, host from mysql.user where File_priv = 'Y' and user <> ‘root’
action_sql_change
update mysql.user set file_priv = 'N' where user = $user and host = $host;

The commands contained in this output file must be executed directly on the database, and in this procedure we are using the mysql command line utility like this:

root@instance_name:/# mysql -u root -p

The password will be required using the command -p ...

MariaDB [(none)]> use mysql;
MariaDB [mysql]> select user, host from mysql.user where File_priv = 'Y' and user <> ’root’;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| db_sysadm        | localhost | 
| user1            | localhost |
+------------------+-----------+
1 row in set (0.00 sec)
MariaDB [mysql]> update mysql.user set file_priv = 'N' where user = ‘user1’ and host = ‘localhost’;
MariaDB [mysql]> Flush privileges;
MariaDB [mysql]>exit

As in the example above, it is necessary to assess whether the privilege is suitable for the users listed and make the change in the necessary cases.
After performing all the procedures, it is necessary to restart the instance to apply the modifications, like this:

root@instance_name:/# sudo /etc/init.d/mysql restart

Notes: Only users with administrative privileges are able to change the SQL instance settings

References: 
http://www.itsecure.hu/library/image/CIS_Oracle_MySQL_Community_Server_5.7_Benchmark_v1.0.0.pdf
https://mariadb.com/kb/en/system-variable-differences-between-mariadb-102-and-mysql-57/
http://dev.mysql.com/doc/mysql/en/server-system-variables.html
https://cloud.google.com/sdk/gcloud/reference/components
