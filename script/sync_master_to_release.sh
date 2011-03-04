#!/bin/bash
#
# script/sync_master_to_release.sh
git checkout release
git merge master
git checkout master