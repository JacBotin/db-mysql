select 'datadir = ''/$path/datafiles/data''' as action_mycnf, concat('chmod 700 ', @@global.datadir)  as action_cmd_permission, concat('chown mysql:mysql ', @@global.datadir) as action_cmd_change_owner
union 	   
select 'log_error= ''/$path/logs/mysql_error.log''' as action_mycnf, concat('chmod 700 ',  @@global.log_error)  as action_cmd_permission, concat('chown mysql:mysql ', @@global.log_error) as action_cmd_change_owner
union
select 'slow_query_log_file = ''/$path/logs/mysql-slow.log'''  as action_mycnf, concat('chmod 700 ', @@global.slow_query_log_file)  as action_cmd_permission, concat('chown mysql:mysql ', @@global.slow_query_log_file) as action_cmd_change_owner  
union      
select 'general_log_file = ''/$path/logs/mysql-general.log'''   as action_mycnf, concat('chmod 700 ', @@global.general_log_file)  as action_cmd_permission, concat('chown mysql:mysql ', @@global.general_log_file) as action_cmd_change_owner  
union
select 'log_bin_basename = ''/$path/binlogs/mysql-bin'''  as action_mycnf, concat('chmod 700 ', @@global.log_bin_basename)  as action_cmd_permission, concat('chown mysql:mysql ', @@global.log_bin_basename) as action_cmd_change_owner  
union
select 'relay_log_basename = ''/$path/binlogs/relay-bin'''  as action_mycnf, concat('chmod 700 ', @@global.log_bin_basename)  as action_cmd_permission, concat('chown mysql:mysql ', @@global.log_bin_basename) as action_cmd_change_owner  
union 	   
select 'secure_file_priv = ''/$path/backups'''  as action_mycnf, concat('chmod 700 ', case when @@global.secure_file_priv is null then '/$path/backups' else @@global.secure_file_priv end )  as action_cmd_permission, concat('chown mysql:mysql ', case when @@global.secure_file_priv is null then '/$path/backups' else @@global.secure_file_priv end ) as action_cmd_change_owner; 