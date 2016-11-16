#!/bin/bash
#
# deploy.sh
#
# Copyright (c) 2016 Ben Lindsay <benjlindsay@gmail.com>

cd _site
git commit -am "Site updated on $(date)"
git push origin master
