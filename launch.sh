#!/usr/bin/env bash
export CONFIGPROXY_AUTH_TOKEN=`openssl rand -hex 32`
cd /home/ubuntu
jupyterhub
