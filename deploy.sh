#!/bin/sh

grunt build
git add -A dist
git commit -m "Update dist/"
git push origin master
git push heroku master
