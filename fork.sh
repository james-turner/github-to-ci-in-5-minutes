#!/usr/bin/env bash

CURR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)
git clone https://github.com/james-turner/github-to-ci-in-5-minutes.git $TMP_DIR
cd $TMP_DIR
git archive --format=tar HEAD | (cd $CURR_DIR && tar xf -)
cd $CURR_DIR
rm fork.sh

