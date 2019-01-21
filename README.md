#  Docker to Setup Magento 2 with Sample Data

### Nginx + PHP 7.0 + OPCache + MySQL +  Redis + Crontab

[![Build Status](https://img.shields.io/docker/build/rafaelcgstz/magento2.svg)](https://hub.docker.com/r/ahsandev/magento2.2/)
[![Docker Pulls](https://img.shields.io/docker/pulls/rafaelcgstz/magento2.svg)](https://hub.docker.com/r/ahsandev/magento2.2/)
[![Docker Starts](https://img.shields.io/docker/stars/rafaelcgstz/magento2.svg)](https://hub.docker.com/r/ahsandev/magento2.2/)


### Requirements

**MacOS:**

Install [Docker](https://docs.docker.com/docker-for-mac/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-OSX).

**Windows:**

Install [Docker](https://docs.docker.com/docker-for-windows/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-Windows).

**Linux:**

Install [Docker](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/) and [Docker-compose](https://docs.docker.com/compose/install/#install-compose).

### How to Install

1. Clone repository
2. Go to directory
3. Run ./init command in terminal


### Panels
Enjoy your new panels!

Web server: 
    Admin: http://127.0.0.1:5022/admin
      👤 User: admin
      🔑 Password: admin@123
      🌎 Front-end: http://127.0.0.1:5022/

PHPMyAdmin: http://localhost:1022/


### Features commands

Access your container

./shell	OR ./shell root

Use the power of the Magento CLI

./magento

Deploy Static files

./deploy
