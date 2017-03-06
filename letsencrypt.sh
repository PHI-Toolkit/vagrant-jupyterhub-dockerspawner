#!/usr/bin/env bash

certbot-auto certonly \
  --debug \
  --no-self-upgrade \
  --standalone \
  --agree-tos \
  --non-interactive \
  --rsa-key-size 4096 \
  --email $LETSENCRYPT_EMAIL \
  --domains $LETSENCRYPT_HOST
