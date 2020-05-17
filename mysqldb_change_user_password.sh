# This script changes the password of the informed user
#
echo "Enter the Mysql Host:";
read hostname;
echo "Enter mysql root password (password not shown):"
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
echo "Enter the name of the user mysql who wants to change the password:";
read username;
echo "Enter the name of the user mysql you want to change the password (password not shown)"
unset upassword;
while IFS= read -r -s -n1 pass; do
  if [[ -z $upass ]]; then
     echo
     break
  else
     echo -n '*'
     upassword+=$upass
  fi
done
mysql -h $hostname -u root -p$password -e "update user set authentication_string=password('$upassword'), plugin='mysql_native_password' where User='$username'; \
                  flush privileges;"