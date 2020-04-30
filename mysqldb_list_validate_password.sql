
-- after install plugin 'validate_password' 

select 'validate_password_policy' as name_variable,
	   @@global.validate_password_policy as value_variable,
	  'The validate_password_policy value can be specified using numeric values 0, 1, 2, or the corresponding symbolic values LOW, MEDIUM, STRONG. The following table describes the tests performed for each policy. 0-LOW - Check only the length, 1-MEDIUM - Check length, numeric, lowercase / uppercase and special characters. 2-STRONG - Check length, numeric, lowercase / uppercase and special characters, dictionary file' as description_variable,	   
	   CASE WHEN @@global.validate_password_policy = 'MEDIUM'
	        THEN 'OK - Control minimum of criteria of requirement for user password is defined'
	        else 'NOK - Control of minimum number of special characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_policy = 'MEDIUM'
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_policy = MEDIUM;'
            END AS action_cmd  
union 
select 'validate_password_length' as name_variable,
	   @@global.validate_password_length as value_variable,
	  'This variable control the minimum number of characters that validate_password requires passwords to have' as description_variable,	   
	   CASE WHEN @@global.validate_password_length >= 14
	        THEN 'OK - The minimum number of characters that validate_password is defined 14 characters'
	        else 'NOK - The minimum number of characters that validate_password is NOT defined or is defined with less of 14 characters' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_length >= 14
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_length = 14;'
            END AS action_cmd  
union 
select 'validate_password_check_user_name' as name_variable,
	   @@global.validate_password_check_user_name as value_variable,
	  'This variable controls user name matching. Compares passwords to the user name part of the effective user account for the current session and rejects them if they match' as description_variable,	   
	   CASE WHEN @@global.validate_password_check_user_name = 1
	        THEN 'OK - Control to prevent the password from being the same as the users name is enabled'
	        else 'NOK - Control to prevent the password from being the same as the users name is disabled' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_check_user_name = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_check_user_name = ON;'
            END AS action_cmd  
union             
select 'validate_password_mixed_case_count' as name_variable,
	   @@global.validate_password_mixed_case_count as value_variable,
	  'The minimum number of lowercase and uppercase characters that validate_password requires passwords to have if the password policy is MEDIUM or stronger.' as description_variable,	   
	   CASE WHEN @@global.validate_password_mixed_case_count = 1
	        THEN 'OK - Control of minimum number of lowercase and uppercase characters requirement for user password is defined'
	        else 'NOK - Control of minimum number of lowercase and uppercase characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_mixed_case_count = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_mixed_case_count = 1;'
            END AS action_cmd  
union             
select 'validate_password_number_count' as name_variable,
	   @@global.validate_password_number_count as value_variable,
	  'The minimum number of numbers characters that validate_password requires passwords to have if the password policy is MEDIUM or stronger.' as description_variable,	   
	   CASE WHEN @@global.validate_password_number_count = 1
	        THEN 'OK - Control of minimum number of numbers characters requirement for user password is defined'
	        else 'NOK - Control of minimum number of numbers characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_number_count = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_number_count = 1;'
            END AS action_cmd  
union             
select 'validate_password_special_char_count' as name_variable,
	   @@global.validate_password_special_char_count as value_variable,
	  'The minimum number of specials characters that validate_password requires passwords to have if the password policy is MEDIUM or stronger.' as description_variable,	   
	   CASE WHEN @@global.validate_password_special_char_count = 1
	        THEN 'OK - Control of minimum number of special characters requirement for user password is defined'
	        else 'NOK - Control of minimum number of special characters requirement for user password is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.validate_password_special_char_count = 1
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL validate_password_special_char_count = 1;'
            END AS action_cmd  


