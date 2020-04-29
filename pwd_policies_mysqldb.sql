-- Controle de Política de senhas 

SHOW VARIABLES LIKE 'validate_password%';
-- Lista as variáveis de controle de validação de senhas
-- Se o resultado deste comando é null, significa que o plugin de validação de senha não está instalado.
-- Comando para instalar o plugin de validação de senha 
INSTALL PLUGIN validate_password SONAME 'validate_password.so';


-- Lista se o plugin instalado está ativo
SELECT PLUGIN_NAME, PLUGIN_STATUS 
FROM INFORMATION_SCHEMA.PLUGINS 
WHERE PLUGIN_NAME LIKE 'validate%';

-- Após instalação do plugin, as variáveis de validação de senha devem ser exibidas
SHOW VARIABLES LIKE 'validate_password%';

-- Habilita controle para impedir que a senha seja o mesmo nome do user 
SET GLOBAL validate_password_check_user_name = ON;

-- exige o mínimo 8 digitos como valor da senha
SET GLOBAL validate_password_length = 8;

-- exige o mínimo de caracteres Maiúsculos no valor da senha
SET GLOBAL validate_password_mixed_case_count = 1;

-- exige o mínimo de caracteres númericos no valor da senha
SET GLOBAL validate_password_number_count = 1;

-- exige o mínimo de caracteres especiais no valor da senha
SET GLOBAL validate_password_special_char_count=1;

-- Critério de política de senha
-- 0 - LOW - valida apenas o comprimento (tamanho)
-- 1 - MEDIUM - Comprimento; caracteres numéricos, minúsculos / maiúsculos e especiais
-- 2 - STRONG - Comprimento; caracteres numéricos, minúsculos / maiúsculos e especiais; arquivo de dicionário
SET GLOBAL validate_password_policy = MEDIUM;

SHOW VARIABLES LIKE 'default_password_lifetime';
-- exige troca de senha a cada 90 dias
SET GLOBAL default_password_lifetime=90;

--
-- 5.6
-- UPDATE mysql.user SET plugin = 'mysql_native_password', authentication_string = PASSWORD('changeme') 
-- WHERE User = 'root';
-- FLUSH PRIVILEGES;
-- 5.7 or more
-- ALTER USER 'root'@'localhost' IDENTIFIED BY 'NEW_PASSWORD';
--

-- Lista user com senha em branco
SELECT User,host FROM mysql.user WHERE authentication_string='';

-- Lista user anônimo
SELECT user,host FROM mysql.user WHERE user = '';


-- necessário reiniciar serviço 
-- sudo service mysql restart


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


