#!/usr/bin/env bash

if [ ! -e venv ]; then
  python3 -m venv venv
fi &&\
venv/bin/pip install -r requirements.txt &&\
echo OK
