#!/bin/bash
#
# deploy.sh
#
# Copyright (c) 2016 Ben Lindsay <benjlindsay@gmail.com>

jekyll build

rsync -rav _site/* rrgroup@eniac.seas.upenn.edu:~rrgroup/public_html/ --delete
