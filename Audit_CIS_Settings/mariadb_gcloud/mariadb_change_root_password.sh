echo "Enter the Instance Database Name:";
read instancedb_name;
echo "Enter new database root password (password not shown)"
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

gcloud sql instances set-root-password $instancedb_name --password $pass