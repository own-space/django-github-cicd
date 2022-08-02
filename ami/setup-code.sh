sleep 30
sudo yum update -y
sleep 10
echo "installing git"
sudo yum install git -y
sudo yum install python3-pip -y
# sudo yum install libpq-dev python-dev -y
# update pip3 to latest version
python3 -m pip install --upgrade pip
# upgrade pillow library
# python3 -m pip install --upgrade Pillow

# update PATH 
export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:/usr/local/bin" >> ~/.bash_profile
sleep 1
source ~/.bash_profile

sleep 10
mkdir -p ~/.ssh
touch /root/.ssh/id_rsa
cat /tmp/superrirya_github >> ~/.ssh/id_rsa

chmod +x /tmp/mkssh.sh
/tmp/mkssh.sh

git config --global user.name "superriya"
git config --global user.email "supriya-sontakke@hotmail.com"
eval $(ssh-agent -s)
chmod 600 ~/.ssh/id_rsa 
ssh-add ~/.ssh/id_rsa
ssh-keyscan github.com >> ~/.ssh/known_hosts
#rm -f /tmp/superrirya_github

pip3 install psycopg2-binary

sleep 10
git clone --branch main git@github.com:superriya/sumits-blogsite.git /src
me=`whoami`
sudo chown -Rf $me /src

#pip3 install --upgrade pip
pip3 install -r /tmp/requirements.txt

#setting APP_DIR
export APP_DIR=/src/app
echo "export APP_DIR=/src/app" >> ~/.bash_profile
echo "export APP_DIR=/src/app" >> /home/ec2-user/.bash_profile

# script to create unique id for app secret key
echo 'import uuid' > /tmp/generate_secret.py
echo 'print(uuid.uuid4())' >> /tmp/generate_secret.py
secret_key=`python3 /tmp/generate_secret.py`
echo "NEW_APP_SECRET_KEY='${secret_key}'" | tee /src/app/BlogWebsite/env

touch /src/app/BlogWebsite/.env
cat << EOF > /src/app/BlogWebsite/.env
DB_PASSWORD="ddf5d97a68be883cdad5610ad9c2c6c37c1f8eb6a995c713df49944a00032eda"
DJANGO_SECRET_KEY="${APP_SECRET}"
SECRET_KEY="${secret_key}"
DB_USER="${DB_APP_USER}"
DB_NAME="${DB_NAME}"
DB_PWD="${DB_PWD}"
DB_HOST="${DB_HOST}"
DB_PORT="${DB_PORT}"
EOF

touch /src/app/BlogWebsite/env
cat << EOF > /src/app/BlogWebsite/env
DB_PASSWORD="ddf5d97a68be883cdad5610ad9c2c6c37c1f8eb6a995c713df49944a00032eda"
DJANGO_SECRET_KEY="${APP_SECRET}"
DB_USER="${DB_APP_USER}"
DB_NAME="${DB_NAME}"
DB_PWD="${DB_PWD}"
DB_HOST="${DB_HOST}"
DB_PORT="${DB_PORT}"
EOF

python3 /src/app/manage.py makemigrations
python3 /src/app/manage.py migrate

sudo chown -Rf ec2-user /src


# update settings file to allow hosts from other domains
sed -i 's/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \[\"*\"\]/g' /src/app/BlogWebsite/settings.py
