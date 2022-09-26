#!/usr/bin/env bash

. venv/bin/activate &&\
uvicorn t2ik.app:app --reload
