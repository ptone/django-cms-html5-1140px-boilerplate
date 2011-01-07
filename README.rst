Stop peeling. Start cooking!
============================

At bitmazk we create beautifull handcrafted websites. After nearly 10 years
of web development it turned out that a simple apache / django / django-cms
stack works best for us and our customers.

To streamline the process of setting up new projects for new customers we
created this boilerplate. Stop peeling. Start cooking!

Ingredients
===========

  - automated setup of your virtualenv
  - automated setup of an empty test database
  - html5_ ready
  - based on django-cms_
  - ready for mobile browsers thanks to the 1140px-CSS-framework_
  - using django-compressor_
    for combining, compressing and minifying static files
  - SASS_ support
  - ready for deployment at Webfaction_

Preparation
===========

You will need quite some tools such as
mysql, virtualenv_, virtualenvwrapper_, csstidy_, sass_ and some more. Have a
look at our bitmazk-environment_ for a full list of tools and libraries needed.

*IMPORTANT:* Be very sure that you have virtualenvwrapper installed properly.
We added a check for virtualenvwrapper.sh but who knows, maybe you get around
that - and without virtualenvwrapper this script might pollute your global
python environment with unwanted modules.

Recipe
======

  - Clone this repository,
  - initiate the project

::

  git clone git://github.com/bitmazk/django-cms-html5-1140px-boilerplate.git yourproject
  cd yourproject
  ./bin/init.sh
  cd webapps/django/project
  workon yourvirtualenv
  python manage.py syncdb --all
  python manage.py migrate --fake
  python manage.py runserver

HTML5 Boilerplate and SASS
==========================
We are standing on the shoulders of giants and use the awesome
html5-boilerplate_ as a submodule.

Usually the main .css file that comes with the html5-boilerplate has a part
somewhere in the middle of the file where your very own styles should go.
In order to be able to define these styles with SASS ``initproject.sh`` slices
that main .css file into two pieces. Now you can define your own styles in a
.sass file and let django-compressor take care of combining and compressing
everything.

Unfortunately we have to inject quite some django specific code into the
``index.html`` that comes with the html5-boilerplate. Therefore this repo ships
with its own ``base.html`` and we don't ever touch the html5-boilerplate's
``index.html``. Maybe this can be automated in the future so that our
``base.html`` will be generated out of ``index.html`` but for now be warned:
Our ``base.html`` might not reflect latest and important changes to the
html5-boilerplate's ``index.html``. We will try to monitor changes there and add
them to our ``base.html`` manually but we are just humans. And we are damn busy.
So you better check it yourself as well.

If you find our ``base.html`` horribly outdated, please create an issue and we
will take care quickly.

The Database
============
We are used to MySQL. Sorry for that! The init.sh script will ask you for
a database name/user/password and your MySQL Root password. It will then use
your root password to drop and delete that user and database if it already
exists. So plase *think twice*! After that the user and the database will get
recreated.

When creating a project based on this boilerplate you might want to import
the production database every now and then for debugging purposes. To make
this easier we added import-database.sh. If you chose to import another database
into a different database user / name / password, don't forget to update your
local_settings.py.

Hosting at Webfaction
=====================

You might wonder about the folder structure of this project. We chose this
structure because it reflects the structure on our hosted webservers at our
awesome webhost Webfaction_.

We usually have one static app for serving static files plus one django app for
serving the django application. A deployment script on the server checks out the
repository and copies everything to its destination via rsync. We might release
that script in the future as well...

License
=======

`The Unlicense <http://unlicense.org//>`_

.. _django-cms: https://github.com/divio/django-cms
.. _django-compressor: https://github.com/mintchaos/django_compressor
.. _SASS: http://sass-lang.com/
.. _Webfaction: http://www.webfaction.com
.. _virtualenv: http://pypi.python.org/pypi/virtualenv/
.. _virtualenvwrapper: http://pypi.python.org/pypi/virtualenv/
.. _csstidy: http://csstidy.sourceforge.net/
.. _sass: http://sass-lang.com/
.. _bitmazk-environment: https://github.com/bitmazk/bitmazk-environment
.. _html5-boilerplate: https://github.com/paulirish/html5-boilerplate
.. _html5: https://github.com/paulirish/html5-boilerplate
.. _1140px-CSS-framework: http://cssgrid.net/

