# blickblock-js

Blicblock is a game your Sims in The Sims 4 can play on the computer. I thought
it would be fun to recreate the game. Our Sims shouldn't have all the fun!

## Notes about Blicblock:

- Looks like Tetris meets Bejeweled: colored blocks fall down. Combine them into Tetrominos and the Tetromino disappears.
- Disappearing Tetrominos cause blocks on top of them to fall, which can cause cascades of disappearing blocks.
- If screen fills up and no more blocks can fall, game over.
- Colors: magenta, yellow, green, blue
- Five blocks across, seven tall
- Preview of next two blocks shown

![](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/app/images/blicblock-screenshot-1.png)

![](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/app/images/blicblock-screenshot-2.png)

## How to Run

1. `npm install`
1. `npm install -g bower`
1. `bower install`
1. `npm install -g grunt-cli`
1. `grunt serve` to watch for file changes.

## How to Deploy to Heroku

Create a new Heroku app in your browser.

1. `npm install`
1. `npm install -g bower`
1. `bower install`
1. `npm install -g grunt-cli`
1. `grunt build`
1. `git remote add heroku git@heroku.com:yourherokuapp.git`
1. `git push heroku master`
1. `heroku ps:scale web=1`
1. `heroku config:add NODE_ENV=production`
