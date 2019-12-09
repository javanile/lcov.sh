#!/bin/bash
set -e

git add .
git commit -am "release $(date)"
git push
