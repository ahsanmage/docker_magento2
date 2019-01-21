![Magento 2](https://cdn.rawgit.com/rafaelstz/magento2-snippets-visualstudio/master/images/icon.png)

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

### How to use

Execute in your terminal, change the *docker_magento2* to use the name of your project:

```
curl -s https://raw.githubusercontent.com/ahsanmage/docker_magento2/master/init | bash -s docker_magento2 clone
```

If you want to install the Magento 2, use like that:

```
cd MYMAGENTO2
./shell
rm index.php
install-magento2
```

You can specify the version that want install (e.g. `install-magento2 2.2`).

### Panels

Enjoy your new panels!

**Web server:** http://localhost/

**PHPMyAdmin:** http://localhost:1022


### Features commands

| Commands  | Description  | Options & Examples |
|---|---|---|
| `./init`  | If you didn't use the CURL setup command above, please use this command changing the name of the project.  | `./init MYMAGENTO2` |
| `./start`  | If you continuing not using the CURL you can start your container manually  | |
| `./stop`  | Stop your project containers  | |
| `./kill`  | Stops containers and removes containers, networks, volumes, and images created to the specific project  | |
| `./shell`  | Access your container  | `./shell root` | |
| `./magento`  | Use the power of the Magento CLI  | |
| `./n98`  | Use the Magerun commands as you want | |
| `./grunt-init`  | Prepare to use Grunt  | |
| `./grunt`  | Use Grunt specifically in your theme or completely, it'll do the deploy and the watcher.  | `./grunt luma` |
| `./xdebug`  |  Enable / Disable the XDebug | |
| `./composer`  |  Use Composer commands | `./composer update` |

### Elasticsearch 

To use elastic search you can use this command below:

`$ docker-compose -f docker-compose.yml -f docker-compose.elasticsearch.yml up`

or to run in the background using detached mode

`$ docker-compose -f docker-compose.yml -f docker-compose.elasticsearch.yml up -d`

**Elasticsearch:** http://localhost:9200

### License

MIT © 2018 [contributors](https://github.com/ahsanmage/).


Step-by-step instructions
Follow the steps below in order to build and push your Docker image.

 

Step 1: Prep your machine
Create a GitHub repository that will hold the code to build the image. If you do not have your own Dockerfile or application, please feel free to clone our sample here: https://github.com/devops-recipes/node_app
Create an account on Docker Hub.
Install Docker on your local machine. [Refer to the Docker Getting Started Guide]
Login to Docker Hub: docker login with your credentials.  [Refer to the docker login docs for a complete reference]
docker login --username=yourhubusername --password=yourpassword
 

Step 2: Build and Push image
Your Dockerfile will look something like this:
Dockerfile

FROM readytalk/nodejs

# Add our configuration files and scripts
WORKDIR /app
ADD . /app
RUN npm install
EXPOSE 80

ENTRYPOINT ["/nodejs/bin/npm", "start"]
Build your image by executing the docker build command. DOCKER_ACC is the name of your account $DOCKER_REPO is your image name and $IMG_TAG is your tag
docker build -t $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG .
Now, you can push this image to your hub by executing the docker push command.
sudo docker push $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG
