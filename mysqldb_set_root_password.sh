# This script changes the root password of the mysql database when the password is set to root of the operating system
#
echo "Enter new mysql root password (password not shown)";
unset password;
while IFS= read -r -s -n1 pass; do
  if [[ -z $pass ]]; then
     echo
     break
  else
     echo -n '*'
     password+=$pass
  fi
done
mysql -u root -e "update user set authentication_string=password('$password'), plugin='mysql_native_password' where User='root'"
mysql -u root -e "flush privileges"