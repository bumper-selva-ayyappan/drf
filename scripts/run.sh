#!/bin/sh

set -e # stop running the subsequent command if any lines of our script fails

python manage.py wait_for_db
python manage.py collectstatic --noinput # this will collect all the static files of the project and put them into a configured static file directory
python manage.py migrate


# uwsgi: This is the command to start the uWSGI server.
# --socket :9000: This tells uWSGI to create a socket on port 9000. Other programs can connect to this socket to communicate with the uWSGI server.
# --workers 4: This tells uWSGI to use 4 worker processes. Each worker process can handle one request at a time, so more workers allow the server to handle more simultaneous requests.
# --master: This tells uWSGI to run in master mode. In this mode, uWSGI can dynamically adjust the number of worker processes based on the load, and it can restart workers that die due to bugs or memory leaks in the application.
# --enable-threads: This tells uWSGI to enable threading. This allows each worker process to handle multiple requests at the same time using threads.
# --module app.wsgi: This tells uWSGI to load the WSGI application defined in the app.wsgi module. WSGI (Web Server Gateway Interface) is a standard interface between web servers and Python web applications.
# So, in summary, this command starts a uWSGI server on port 9000 with 4 worker processes, in master mode with threading enabled, and it loads the WSGI application from the app.wsgi module.
uwsgi --socket :9000 --workers 4 --master --enable-threads --module app.wsgi