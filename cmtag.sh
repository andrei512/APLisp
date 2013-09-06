#!/bin/bash

git add .
git ci -am "$1"
git push
git tag -d $2 
git tag -a $2 -m "$1"
git push origin --tags

