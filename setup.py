#!/usr/bin/env python3
from setuptools import setup, find_packages
from os import path
import time

if path.exists("VERSION.txt"):
    # this file can be written by CI tools (e.g. Travis)
    with open("VERSION.txt") as version_file:
        version = version_file.read().strip().strip("v")
else:
    version = str(time.time())

setup(
    name='text-2-image-kiosk',
    version=version,
    packages=find_packages(exclude=['contrib', 'docs', 'tests*', 'frontend', 'bin', 'venv']),
    include_package_data=True,
)
