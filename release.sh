#!/usr/bin/env bash

tag=$1

git tag $tag   # new tag

# move semantic moving pointer
git tag -d v2            # deletes local v2 tag
git tag v2               # creates v2 at HEAD
git push --delete origin v2  # removes remote v2 tag
git push origin v2    # pushes new v2 tag to remote
git push origin $tag  # pushes new tag to remote