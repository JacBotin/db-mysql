-- Audit log Control 

/*
The audit log plugin can filter audited events. This enables you to control whether audited events are written to the audit log file based on the account from which events originate or event status. 
Status filtering occurs separately for connection events and statement events

-- Check plugin audit_log is enable
SELECT PLUGIN_NAME, PLUGIN_STATUS 
FROM INFORMATION_SCHEMA.PLUGINS 
WHERE PLUGIN_NAME LIKE 'audit_log%';

-- If the result of this command is null, it means that the audit log plugin is not installed.
--
--
--
*/
-- To install:   
INSTALL PLUGIN audit_log SONAME 'audit_log.so';

set global audit_log_connection_policy = ALL;

SET GLOBAL audit_log_exclude_accounts = NULL;

SET GLOBAL audit_log_include_accounts = NULL;

SET GLOBAL audit_log_policy = ALL;

SET GLOBAL audit_log_statement_policy = ALL;