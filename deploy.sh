#!/bin/bash

set -e
git checkout dev
git pull origin dev
git checkout master
git pull origin master
git merge dev
git push origin master
