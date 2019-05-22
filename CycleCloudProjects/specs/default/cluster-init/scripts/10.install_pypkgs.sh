#!/bin/bash
set -ex

# Set here the pip installable package names
PY_PACKAGES=dask

# make a /mnt/resource/apps directory
# Azure VMs that have ephemeral storage have that mounted at /mnt/resource. If that does not exist this command will create it.
mkdir -p /mnt/resource/apps

# Make sure pip is installed
yum -y install python-pip

# Install python packages

# make sure we install on the system not inside the jetpack environment
export PATH=/usr/bin:${PATH}

pip install ${PY_PACKAGES}
