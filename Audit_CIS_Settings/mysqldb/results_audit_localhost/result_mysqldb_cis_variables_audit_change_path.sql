SET GLOBAL datadir = '/$path/datafiles/data'; /*Check directory and access control*/
SET GLOBAL log_error= '/$path/logs/mysql_error.log'; /*Check directory and access control */
SET GLOBAL slow_query_log_file = '/$path/logs/mysql-slow.log';  /*Check directory and access control*/
SET GLOBAL general_log_file = '/$path/logs/mysql-general.log';  /*Check directory and access control*/
SET GLOBAL log_bin_basename = '/$path/binlogs/mysql-bin'; /*Check directory and access control */
SET GLOBAL relay_log_basename = '/$path/binlogs/relay-bin';  /*Check directory and access control*/
SET GLOBAL secure_file_priv = '/$path/backups';  /*Check directory and access control*/
