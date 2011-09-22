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

source $venvwrappersh
echo "Installing all needed modules into a virtualenv"
mkvirtualenv -p python2.7 $virtualenvname
workon $virtualenvname
pip install -r bin/requirements.txt

echo "Updating git submodules..."
git submodule update --init --recursive

echo "Creating static folders..."
mkdir ./webapps/static
mkdir ./webapps/media
mkdir ./webapps/django/project/static
mkdir ./webapps/django/project/static/img
mkdir ./webapps/django/project/static/css
mkdir ./webapps/django/project/static/js
touch ./webapps/django/project/static/css/styles.sass

echo "Copying the parts of html5-boilerplate that we need..."
cp ./lib/html5-boilerplate/404.html ./webapps/django/project/templates/404.html
cp ./lib/html5-boilerplate/apple-touch-icon* ./webapps/django/project/static/img/
cp ./lib/html5-boilerplate/favicon.ico ./webapps/django/project/static/img/favicon.ico
cp ./lib/html5-boilerplate/robots.txt ./webapps/django/project/static/robots.txt
cp -r ./lib/html5-boilerplate/js ./webapps/django/project/static/
cp -r ./lib/html5-boilerplate/css ./webapps/django/project/static/

echo "Copying the parts of 1140px css grid that we need..."
cp ./lib/1140px/1140.css ./webapps/django/project/static/css/1140.css
cp ./lib/1140px/ie.css ./webapps/django/project/static/css/ie.css

echo "Splitting up html5-boilerplate css..."
SPLIT=`grep -n "/* Primary Styles" ./webapps/django/project/static/css/style.css | awk -F":" '{ print $1 }'`
SPLITHEAD=`expr $SPLIT - 1`
SPLITTAIL=`expr $SPLIT + 3`
head --lines=$SPLITHEAD ./webapps/django/project/static/css/style.css > ./webapps/django/project/static/css/boilerplate.css
tail -n +$SPLITTAIL ./webapps/django/project/static/css/style.css > ./webapps/django/project/static/css/boilerplate_media.css

echo "Removing the parts we dont want..."
rm -rf .git
rm .gitignore
rm .gitmodules
rm README.rst
rm ./webapps/django/project/static/css/style.css

echo "Creating local_settings.py ..."
cd webapps/django/project/
cp local_settings.py.sample local_settings.py
cd ../../..
sed -i s@projectroot@$(pwd)/@g webapps/django/project/local_settings.py

echo "Remove lib folder..."
cp ./lib/.gitignore .
rm -rf ./lib/

echo "Initiate a new git project..."
git init
git add .
git commit -m "Initial Commit"

workon $virtualenvname
cd webapps/django/project
./manage.py syncdb --migrate
./manage.py collectstatic
./manage.py runserver

echo "Don't forget to change your secret key in your local_settings.py"
