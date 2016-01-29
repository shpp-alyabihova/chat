#!/bin/bash

SERVICE_NAME=chat
MAIN_DIR="/home/vagrant/opt/"
NAME_DIR=mychat
AUTOSTART_NAME=chat_init
BACK_UP="tmp/&NAME_DIR"
AUTOSTART=/etc/init.d/$SERVICE_NAME
GIT_CHAT="https://github.com/shpp-alyabihova/chat.git"

mkdir -p $MAIN_DIR/$NAME_DIR/node_modules
mkdir -p BACK_UP 

for app in curl git
do
	I=`dpkg -s $app | grep "Status"`
	if [ ! -n "$I" ] ; then
		echo "installing $app"
		sudo apt-get -y install $app
	fi
done

if [ ! -n "`dpkg -s nodejs | grep "Status"`" ]; then
	echo "installing node.js and npm"
		sudo apt-get -y update
		sudo apt-get -y install nodejs
		sudo apt-get -y update
		sudo apt-get -y install npm
fi

if [ -f $MAIN_DIR/$NAME_DIR ]
	then
		echo "execute back up"
		cp $MAIN_DIR/$NAME_DIR/* $BACK_UP
		rm -f $MAIN_DIR/$NAME_DIR/*
else
	cd $MAIN_DIR/$NAME_DIR
	for module in forever express socket.io mysql
	do
		echo "installing $module in `pwd`"
		sudo npm -y install $module
	done
	npm init
	npm install
	echo "download source chat"
	sudo git clone $GIT_CHAT
fi

cd /etc/init.d/
echo "create autorun chat"
cp MAIN_DIR/AUTOSTART_NAME $AUTOSTART
sudo chmod a+x $AUTOSTART
sudo update-rc.d $SERVICE_NAME defaults

	

