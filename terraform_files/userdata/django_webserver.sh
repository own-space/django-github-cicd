python3 /src/application/manage.py makemigrations && python3 /src/application/manage.py migrate
nohup python3 /src/application/manage.py runserver 0.0.0.0:4000 > /dev/null 2>&1 &
# sed -i 's/DB_NAME/PRDB_NAME/g' /src/application/django_app/.env
# echo 'DB_NAME="bloglocalv1"' >> /src/application/django_app/.env
# python3 /src/application/manage.py dumpdata auth > /src/application/initial_data_auth.json
# cp /src/application/django_app/env /src/application/django_app/.env
# python3 /src/application/manage.py loaddata /src/application/initial_data_auth.json