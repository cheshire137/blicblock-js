# BlicblockJS

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

1. [Install Node.js](http://nodejs.org/download/).
1. `npm install`
1. `npm install -g bower`
1. `bower install`
1. `npm install -g grunt-cli`
1. `grunt serve` to watch for file changes.

## How to Deploy to Heroku

1. Follow the "How to Run" steps above to get npm, Grunt, Bower, and the necessary packages installed.
1. Create a new Heroku app in your browser.
1. `grunt build`
1. `git remote add heroku git@heroku.com:yourherokuapp.git`
1. `git push heroku master`
1. `heroku ps:scale web=1`
1. `heroku config:add NODE_ENV=production`

## Screenshots of Blicblock in The Sims 4

![The Sims 4 Blicblock play](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/app/images/blicblock-screenshot-1.png)

![The Sims 4 Blicblock game over](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/app/images/blicblock-screenshot-2.png)

## Screenshots of BlicblockJS

![BlicblockJS gameplay](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/blicblockjs-screenshot-1.png)

![BlicblockJS paused](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/blicblockjs-screenshot-2.png)

![BlicblockJS game over](https://raw.githubusercontent.com/moneypenny/blicblock-js/master/blicblockjs-screenshot-3.png)
