# BlicblockJS

Blicblock is a game your Sims in The Sims 4 can play on the computer. I thought
it would be fun to recreate the game. Our Sims shouldn't have all the fun!

![BlicblockJS gameplay](https://raw.githubusercontent.com/cheshire137/blicblock-js/master/blicblockjs-screenshot-1.png)

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

```bash
bundle
bundle exec rake db:create db:migrate db:seed
bundle exec rails s
open http://localhost:3000
```

## How to Test

### Rails API

1. `RAILS_ENV=test bundle exec rake db:create db:migrate`
1. `RAILS_ENV=test bundle exec rspec`

### AngularJS

1. `cd client/`
1. `npm install`
1. `grunt test`

## How to Deploy to Heroku

1. Create a new Heroku app in your browser.
1. `git remote add heroku git@heroku.com:yourherokuapp.git`
1. `heroku config:add BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-ruby.git`
1. `git push heroku master`
1. `heroku addons:add heroku-postgresql`
1. `heroku addons:add pgbackups`
1. `heroku run rake db:migrate`
1. `heroku ps:scale web=1`
1. `heroku config:add NODE_ENV=production`

### How to Backup Heroku PostgreSQL Database

    heroku pg:backups capture
    curl -o latest.dump `heroku pg:backups public-url`

To load the dump file locally:

    pg_restore --verbose --clean --no-acl --no-owner -h localhost -U blicblockjs -d blicblockjs_development latest.dump

## BlicblockJS Mentions

- [The Sims 4: Play "BlicBlock" On Your Browser - SimsVIP](http://simsvip.com/2014/10/03/the-sims-4-play-blicblock-on-your-browser/)
- [The Sims 4 RU - VK](http://vk.com/thesims4ru?w=wall-31385407_119374)
- [The Sims 4: Играем, как симы! - RoleSim](http://rolesim.com/news/sims-4-igraem-kak-simy)
- [Znacie grę BlicBlock z The Sims 4? - Sims True Life](http://simstruelife.pl/News:Znacie_gre_BlicBlock_z_The_Sims_4_04.10.14)
- [le jeu Sims - Blic Block - débarque chez vous! - SimCookie](http://www.simcookie.com/2014/10/06/jeu-sims-blic-block-debarque-chez/)
- [Blicblock, playable version of game depicted in The Sims 4 - RunJumpDev](https://groups.google.com/forum/m/#!topic/runjumpdev/Wn3W625CG34)
- [Play the game your sims playing - Speak No Evil Tumblr](http://brial-immortelle.tumblr.com/post/99095876514/play-the-game-your-sims-playing-its-amazing)

## Blicblock in The Sims 4

[Video of my Sim playing Blicblock](https://www.youtube.com/watch?v=NEiNfe6uaso)

![The Sims 4 Blicblock play](https://raw.githubusercontent.com/cheshire137/blicblock-js/master/client/app/images/blicblock-screenshot-1.png)

![The Sims 4 Blicblock game over](https://raw.githubusercontent.com/cheshire137/blicblock-js/master/client/app/images/blicblock-screenshot-2.png)

## Screenshots of BlicblockJS

![BlicblockJS paused](https://raw.githubusercontent.com/cheshire137/blicblock-js/master/blicblockjs-screenshot-2.png)

![BlicblockJS game over](https://raw.githubusercontent.com/cheshire137/blicblock-js/master/blicblockjs-screenshot-3.png)
