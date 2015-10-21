#!/bin/sh
git archive --prefix=build_scripts/ master | gzip > build_scripts.tar.gz
