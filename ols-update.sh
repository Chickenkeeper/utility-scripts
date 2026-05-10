#!/bin/bash

# NOTE: this needs to be run as root, otherwise it will generate a lot of 'permission denied' errors

if [ -d "/opt/ols" ]; then
    rm -rf /opt/ols/*
else
    mkdir /opt/ols
fi \
&& wget -P /opt/ols https://github.com/DanielGavin/ols/releases/latest/download/ols-x86_64-unknown-linux-gnu.zip \
&& unzip /opt/ols/ols-x86_64-unknown-linux-gnu.zip -d /opt/ols \
&& mv /opt/ols/ols-x86_64-unknown-linux-gnu /opt/ols/ols \
&& mv /opt/ols/odinfmt-x86_64-unknown-linux-gnu /opt/ols/odinfmt \
&& rm /opt/ols/ols-x86_64-unknown-linux-gnu.zip
