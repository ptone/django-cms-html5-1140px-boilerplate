#!/usr/bin/env bash
echo "Setting up a new django-cms development environment."
echo "Answer some questions before running the installation."

echo "What is the path to your virtualenvwrapper.sh?"
echo "Standard is: /usr/local/bin/virtualenvwrapper.sh"
echo "Leave empty to use standard: "
read venvwrappersh
if [ "$venvwrappersh" == "" ]
  then 
    venvwrappersh="/usr/local/bin/virtualenvwrapper.sh"
fi
if [ ! -f $venvwrappersh ]
  then
    echo "ERROR: File $venvwrappersh does not exist..."
    exit 1
fi

echo "Virtualenv name:"
read virtualenvname

echo "Database name:"
read dbname

echo "Database user:"
read dbuser

echo "Database password:"
read dbpassword

echo "MySQL root password:"
stty -echo
read mysqlrootpassword
stty echo

source $venvwrappersh
echo "Installing all needed modules into a virtualenv"
mkvirtualenv -p python2.7 --no-site-packages $virtualenvname
pip install Django
pip install PIL
pip install mysql-python
pip install south
pip install BeautifulSoup
pip install -e git://github.com/divio/django-cms.git#egg=django-cms
pip install -e git://github.com/dziegler/django-css.git#egg=compressor
pip install -e git://github.com/SmileyChris/easy-thumbnails.git#egg=easy-thumbnails
pip install -e git://github.com/stefanfoulis/django-filer.git@master#egg=filer
pip install -e git://github.com/ojii/django-multilingual-ng.git#egg=multilingual

echo "Updating git submodules..."
git submodule update --init --recursive

echo "Creating static folders..."
mkdir ./webapps/static
mkdir ./webapps/static/img
mkdir ./webapps/static/css
mkdir ./webapps/static/js
touch ./webapps/static/css/styles.sass

echo "Copying the parts of html5-boilerplate that we need..."
cp ./lib/html5-boilerplate/404.html ./webapps/django/project/templates/404.html
cp ./lib/html5-boilerplate/apple-touch-icon.png ./webapps/static/img/apple-touch-icon.png
cp ./lib/html5-boilerplate/favicon.ico ./webapps/static/img/favicon.ico
cp ./lib/html5-boilerplate/robots.txt ./webapps/static/robots.txt
cp -r ./lib/html5-boilerplate/js ./webapps/static/
cp -r ./lib/html5-boilerplate/css ./webapps/static/

echo "Copying the parts of 1140px css grid that we need..."
cp ./lib/1140px/1140.css ./webapps/static/css/1140.css
cp ./lib/1140px/smallerscreen.css ./webapps/static/css/smallerscreen.css
cp ./lib/1140px/mobile.css ./webapps/static/css/mobile.css
cp ./lib/1140px/ie.css ./webapps/static/css/ie.css

echo "Splitting up html5-boilerplate css..."
SPLIT=`grep -n "/* Primary Styles" ./webapps/static/css/style.css | awk -F":" '{ print $1 }'`
SPLITHEAD=`expr $SPLIT - 1`
SPLITTAIL=`expr $SPLIT + 3`
head --lines=$SPLITHEAD ./webapps/static/css/style.css > ./webapps/static/css/boilerplate.css
tail -n +$SPLITTAIL ./webapps/static/css/style.css > ./webapps/static/css/boilerplate_media.css

echo "Removing the parts we dont want..."
rm -rf .git
rm README.rst
rm ./webapps/static/css/style.css

echo "Creating symlinks..."
cd webapps/static
echo "What is the name of your virtualenv: "
ln -s $HOME/Envs/$virtualenvname/lib/python2.7/site-packages/django/contrib/admin/media
ln -s $HOME/Envs/$virtualenvname/src/django-cms/cms/media/cms
ln -s $HOME/Envs/$virtualenvname/src/filer/filer/media/filer
ln -s $HOME/Envs/$virtualenvname/src/multilingual/multilingual/media/multilingual
cd ../..

echo "Creating local_settings.py ..."
cd webapps/django/project/
cp local_settings.py.sample local_settings.py
sed -i s/dbname/$dbname/g local_settings.py
sed -i s/dbuser/$dbuser/g local_settings.py
cd ../../..
sed -i s@projectroot@$(pwd)/@g webapps/django/project/local_settings.py

echo "Initiate a new git project..."
git init
git add .
git commit -m "Initial Commit"

echo "Initiate mysql test database..."
mysql --user=root --password=$mysqlrootpassword -e "DROP USER $dbuser;"
mysql --user=root --password=$mysqlrootpassword -e "DROP DATABASE IF EXISTS $dbname;"
mysql --user=root --password=$mysqlrootpassword -e "CREATE USER $dbname IDENTIFIED BY '$dbpassword';"
mysql --user=root --password=$mysqlrootpassword -e "CREATE DATABASE $dbname CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql --user=root --password=$mysqlrootpassword -e "GRANT ALL ON $dbname.* TO $dbuser;"

echo "Don't worry about mysql errors when dropping the user $dbuser!"
echo "Everything is done. Check your $HOME/.pip/pip.log for errors. If some modules couldn't be installed, try again to add them to your virtualenv!"
