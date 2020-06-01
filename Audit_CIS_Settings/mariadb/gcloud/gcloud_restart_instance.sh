
echo "Enter the Instance Database Name:";
read instancedb_name;
gcloud sql instances restart $instancedb_name