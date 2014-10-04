# BlicblockJS

[![Build Status](https://semaphoreapp.com/api/v1/projects/75327b8f-13a9-49f0-9b0c-950db2a63f36/261416/badge.png)](https://semaphoreapp.com/cheshire137/blicblock-js)

Blicblock is a game your Sims in The Sims 4 can play on the computer. I thought
it would be fun to recreate the game. Our Sims shouldn't have all the fun!

BlickblockJS is built using AngularJS, Bower, Yeoman, and Twitter Bootstrap.

## Blicblock Notes from The Sims 4

- Looks like Tetris meets Bejeweled: colored blocks fall down. Combine them into a tetromino and the tetromino disappears.
- Disappearing tetrominos cause blocks on top of them to fall, which can cause cascades of disappearing tetrominos.
- If the screen fills up and no more blocks can fall, game over.
- Five blocks across, seven tall
- Colors: magenta, yellow, green, blue. *Note:* since the game board is five blocks wide, to make the game have any challenge at all, there need to be >5 colors of blocks.
- Preview of next two blocks shown

## How to Run

You need Ruby, RubyGems, Bundler, Node.js, and PostgreSQL.

1. `bundle`
1. Create a `blicblockjs` role in PostgreSQL:

        % psql
        psql (9.2.1)
        Type "help" for help.

        sarah=# CREATE USER blicblockjs WITH PASSWORD 'password';
        CREATE ROLE
        sarah=# ALTER USER blicblockjs WITH SUPERUSER;
        ALTER ROLE

1. `bundle exec rake db:create db:migrate db:seed`
1. `cd client/`
1. `npm install`
1. `npm install -g bower`
1. `bower install`
1. `npm install -g grunt-cli`
1. `grunt serve` to watch for file changes and to launch the Rails server.

## How to Test

### Rails API

1. `RAILS_ENV=test bundle exec rake db:create db:migrate`
1. `RAILS_ENV=test bundle exec rspec`

### AngularJS

1. `cd client/`
1. `npm install`
1. `npm install -g bower`
1. `bower install`
1. `npm install -g grunt-cli`
1. `grunt test`

## How to Deploy to Heroku

1. Create a new Heroku app in your browser.
1. `git remote add heroku git@heroku.com:yourherokuapp.git`
1. `heroku config:add BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-ruby.git`
1. `git push heroku master`
1. `heroku addons:add heroku-postgresql`
1. `heroku run rake db:migrate`
1. `heroku ps:scale web=1`
1. `heroku config:add NODE_ENV=production`

## Screenshots of Blicblock in The Sims 4

![The Sims 4 Blicblock play](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/client/app/images/blicblock-screenshot-1.png)

![The Sims 4 Blicblock game over](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/client/app/images/blicblock-screenshot-2.png)

## Screenshots of BlicblockJS

![BlicblockJS gameplay](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/blicblockjs-screenshot-1.png)

![BlicblockJS paused](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/blicblockjs-screenshot-2.png)

![BlicblockJS game over](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/blicblockjs-screenshot-3.png)
