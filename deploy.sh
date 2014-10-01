#!/bin/sh

cd client
grunt build
cd ..
git add -A public
git commit -m "Update public/"
git push origin master
git push heroku master
