#!/bin/bash
#
# deploy.sh
#
# Copyright (c) 2016 Ben Lindsay <benjlindsay@gmail.com>

rsync -rav _site/* rrgroup@eniac.seas.upenn.edu:/home1/r/rrgroup/html/dynamic/ --delete
