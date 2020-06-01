
At the terminal, execute:

	sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
	or 
        sudo nano /etc/mysql/mariadb.conf.d/mariadb.cnf
        or
        sudo nano /etc/mysql/my.cnf

Edit the variables as shown in the file example "my_example.cnf".

Ctrl-O to save, Ctrl-X to quit

To apply the modifications, it is necessary to restart the mysql service

At the terminal, execute:

	sudo /etc/init.d/mysql restart

