#!/bin/bash

set -e
git checkout dev
git add .
git commit -m "Update from build script" || echo "No changes to commit"
git push origin dev
