#!/usr/bin/env bash
echo "Database name:"
read dbname

echo "Database user:"
read dbuser

echo "Database password (cannot have the character '/'):"
read dbpassword

echo "MySQL root password:"
stty -echo
read mysqlrootpassword
stty echo

echo "Which file do you want to import (i.e. a0bb07a.sql)?"
cd db
latest=`ls -t -r | tail -n 1`
echo "The latest file is $latest (leave empty for latest file):"
read commit
if [ "$commit" == "" ]
  then
    commit="$latest"
fi
if [ ! -f $commit ]
  then
    dir=`pwd`
    echo "ERROR: File $dir/$commit does not exist..."
    exit 1
fi
cd ..

echo "using file $commit"
mysql --user=root --password=$mysqlrootpassword -e "DROP USER $dbuser;"
mysql --user=root --password=$mysqlrootpassword -e "DROP DATABASE IF EXISTS $dbname;"
mysql --user=root --password=$mysqlrootpassword -e "CREATE USER $dbname IDENTIFIED BY '$dbpassword';"
mysql --user=root --password=$mysqlrootpassword -e "CREATE DATABASE $dbname CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql --user=root --password=$mysqlrootpassword -e "GRANT ALL ON $dbname.* TO $dbuser;"

sed -i "1i use $dbname;" db/$commit
mysql --user=$dbuser --password=$dbpassword -h localhost < db/$commit
sed -i '1d' db/$commit 

echo "Database imported. Check your local_settings.py in case you chose different dbuser / dbname / dbpassword than last time"
