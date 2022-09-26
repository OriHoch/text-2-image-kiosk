#!/usr/bin/env bash

cd /home/ubuntu/stable-diffusion
venv/bin/uvicorn ldm.sd_api:app --host 127.0.0.1 --port 8000
