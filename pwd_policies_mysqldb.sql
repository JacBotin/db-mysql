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

