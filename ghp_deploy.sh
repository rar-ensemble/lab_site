#!/bin/bash
#
# deploy.sh
#
# Copyright (c) 2016 Ben Lindsay <benjlindsay@gmail.com>

# change directory to site content directory
cd _site

if [ ! -d .git ]; then
  # initialize git repo if _site doesn't already contain one
  git init
  git remote add origin https://github.com/rigglemanlab/rigglemanlab.github.io.git
fi

# update _site repo to latest commit
git fetch --all
git reset --hard origin/master
# regenerate site content
cd -
jekyll build
cd -
# commmit changes and push to remote
git add .
git commit -m "Site updated on $(date)"
git push origin master
