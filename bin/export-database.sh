#!/bin/sh
echo "Database name:"
read dbname

echo "Database user:"
read dbuser

echo "Database password for user $dbuser:"
read dbpassword

echo "Filename of the dump:"
read filename

mysqldump -u$dbuser $dbname -p$dbpassword > db/$filename 
