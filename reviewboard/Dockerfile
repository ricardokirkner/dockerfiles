# ReviewBoard Dockerfile
#
# VERSION   0.1

FROM base
MAINTAINER Ricardo Kirkner <ricardo@kirkner.com.ar>

# update apt cache
RUN apt-get update

# install base dependencies
RUN apt-get install -y python-setuptools python-dev patch

# install reviewboard
RUN easy_install ReviewBoard

# install supported DVCS
RUN apt-get install -y git-core mercurial bzr

# install external dependencies
RUN apt-get install -y postgresql python-psycopg2
RUN apt-get install -y memcached python-memcache
RUN apt-get install -y apache2 libapache2-mod-wsgi

# configure postgresql
RUN service postgresql start && su -c "createuser -D -l -R -S reviewboard" postgres && su -c "psql -c \"ALTER USER reviewboard WITH PASSWORD 'reviewboard'\"" postgres && su -c "createdb -O reviewboard reviewboard" postgres

# initialize reviewboard
RUN service postgresql start && rb-site install --noinput --domain-name=reviews.local --db-type=postgresql --db-name=reviewboard --db-user=reviewboard --db-pass=reviewboard --cache-type=memcached --web-server-type=apache --python-loader=wsgi --admin-user=admin --admin-password=admin --admin-email=noreply@local /srv/reviews.local

# fix permissions
RUN chown -R www-data /srv/reviews.local/htdocs/media/uploaded /srv/reviews.local/htdocs/media/ext /srv/reviews.local/data /srv/reviews.local/logs

# configure apache
RUN cp /srv/reviews.local/conf/apache-wsgi.conf /etc/apache2/sites-available/reviews.local
RUN a2dissite default
RUN a2ensite reviews.local

# install start script
ADD start_reviewboard /usr/local/sbin/start_reviewboard

# expose active ports
EXPOSE 80

# define default command to run in the container
CMD ["/usr/local/sbin/start_reviewboard"]
