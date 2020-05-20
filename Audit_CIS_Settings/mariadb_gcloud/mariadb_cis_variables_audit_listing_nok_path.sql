select concat("gcloud sql instances patch $INSTANCE_NAME --database-flags ",group_concat(action_cmd))
from
(
select 'datadir = ''/$path/datafiles/data''' as action_cmd
union 	   
select 'slow_query_log_file = ''/$path/logs/mariadb-slow.log''' as action_cmd      
union       
select 'general_log_file = ''/$path/logs/mariadb-general.log'''  as action_cmd
union
select 'log_bin_basename = ''/$path/binlogs/mariadb-bin''' as action_cmd      
union
select 'relay_log_basename = ''/$path/binlogs/relay-bin''' as action_cmd
union 	   
select 'secure_file_priv = ''/$path/backups''' AS action_cmd  ) T;