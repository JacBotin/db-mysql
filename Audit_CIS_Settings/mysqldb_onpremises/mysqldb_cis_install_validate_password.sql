-- Password Policy Control 

/*
-- Check plugin validate_password is enable
SELECT PLUGIN_NAME, PLUGIN_STATUS 
FROM INFORMATION_SCHEMA.PLUGINS 
WHERE PLUGIN_NAME LIKE 'validate_password%';

-- If the result of this command is null, it means that the password validation plugin is not installed.
--
--
--
--
*/
-- To install:   
INSTALL PLUGIN validate_password SONAME 'validate_password.so';

-- Enables control to prevent the password from being the same as the user's name 
SET GLOBAL validate_password_check_user_name = ON;

-- requires a minimum of 14 digits as the password value
SET GLOBAL validate_password_length = 14;

-- requires a minimum of Uppercase characters in the password value
SET GLOBAL validate_password_mixed_case_count = 1;

-- requires a minimum of numeric characters in the password value
SET GLOBAL validate_password_number_count = 1;

-- requires a minimum of special characters in the password value
SET GLOBAL validate_password_special_char_count=1;

-- Password policy criteria
-- 0 - LOW - validates only length (size)
-- 1 - MEDIUM - Length; numeric, lowercase / uppercase, and special characters
-- 2 - STRONG - Length; numeric, lowercase / uppercase and special characters; dictionary file
SET GLOBAL validate_password_policy = MEDIUM;

-- requires password change every 90 days
SET GLOBAL default_password_lifetime=90;


-- need to restart the service 
-- sudo service mysql restart
