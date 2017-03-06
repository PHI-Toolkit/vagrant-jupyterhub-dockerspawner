#!/usr/bin/env bash
sudo ln -sf /bin/bash /bin/sh
sudo apt-get update
sudo apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git nano \
    apt-transport-https curl software-properties-common npm nodejs nodejs-legacy python3-pip supervisor

if [ ! -f /usr/bin/docker ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update
    sudo apt-get install -y  docker-ce
    sudo groupadd docker
    sudo gpasswd -a ubuntu docker
    sudo service docker restart
    cd /vagrant/dockerspawner/singleuser/
    sudo docker build -t jupyterhub/singleuser .
    cd /home/ubuntu
fi

sudo export PATH=$PATH:/opt/conda/:/opt/conda/bin
if [ ! -f /opt/conda/bin/conda ]; then
  wget --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ./miniconda.sh
  sudo chmod a+x miniconda.sh
  sudo ./miniconda.sh -b -p $CONDA_HOME
  sudo rm ./miniconda.sh
  # make conda python packages directories writable by packages group
  sudo addgroup --system package_manager
  sudo chmod -R g+rw $CONDA_HOME/
  sudo chgrp -R package_manager $CONDA_HOME/
  sudo gpasswd -a ubuntu package_manager
fi

echo "setting up channels..."
sudo export PATH=$PATH:/opt/conda:/opt/conda/bin
sudo conda config --add channels conda-forge
sudo conda config --add channels anaconda
sudo conda config --add channels calex
sudo conda config --add channels asmeurer
sudo conda config --add channels amueller

if [ ! -f /usr/local/bin/certbot-auto ]; then
  wget https://dl.eff.org/certbot-auto && \
  sudo chmod a+x certbot-auto && \
  sudo mv certbot-auto /usr/local/bin
fi

# https://github.com/jupyterhub/oauthenticator
if [ ! -d oauthenticator ]; then
    git clone https://github.com/jupyterhub/oauthenticator.git
    sudo chown -R ubuntu:ubuntu /home/ubuntu/oauthenticator/
    cd oauthenticator
    sudo chown -R ubuntu:ubuntu oauthenticator.egg-info/
    sudo pip3 install --upgrade pip
    sudo pip3 install -e .
    cd /home/ubuntu
fi

if [ ! -d dockerspawner ]; then
    git clone https://github.com/jupyterhub/dockerspawner.git
    sudo chown -R ubuntu:ubuntu dockerspawner
fi

# This also installs jupyterhub.
# The singleuser docker container Dockerfile is inside the singleuser directory.
cd dockerspawner
sudo pip3 install -r requirements.txt
sudo python3 setup.py install
sudo npm install -g configurable-http-proxy
sudo pip3 install jupyter_client

cd ..
if [ ! -d ./ssl ]; then
    mkdir ./ssl
    chown -R ubuntu:ubuntu ssl
fi
cp /vagrant/dockerspawner/ssl/* /home/ubuntu/ssl
chown -R ubuntu:ubuntu /home/ubuntu/ssl
cp /vagrant/dockerspawner/userlist /home/ubuntu
chown ubuntu:ubuntu /home/ubuntu/userlist
cp /vagrant/dockerspawner/jupyterhub_config.py /home/ubuntu
chown ubuntu:ubuntu /home/ubuntu/jupyterhub_config.py
#sudo cp /vagrant/dockerspawner/jupyterhub.conf /etc/supervisor/conf.d/
#sudo cp /vagrant/launch.sh /home/ubuntu
#sudo chmod a+x /home/ubuntu/launch.sh
#chown -R ubuntu:ubuntu /home/ubuntu/launch.sh
#sudo cp /vagrant/dockerspawner/jupyterhub.conf /etc/supervisor/conf.d/
