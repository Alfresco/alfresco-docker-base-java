#!/bin/bash

# Alfresco Repo
# Stored like "linux-x64:serverjre:8u181:tar.gz:bin"
export artifacts_repo_url='https://artifacts.alfresco.com/nexus/content/repositories/oracle-java'

# Download directory. Originally meant to be a subdirectory,
# for when we were going to have separate Dockerfiles.
export docker_build_dir='.'
