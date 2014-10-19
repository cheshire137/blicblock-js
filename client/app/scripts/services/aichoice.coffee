'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.aichoice
 # @description
 # # aichoice
 # Service in the blicblockApp.
###

angular.module('blicblockApp')
  .service 'AiChoice', ['$rootScope', '$interval', '$timeout', 'Tetromino', ($rootScope, $interval, $timeout) ->
    class AI
      makeMove: (move) ->
        Tetromino.get_active_block().y = move

      makeChoice: ->
        move = evalColorSpace()
        if move != -1
          makeMove(move)
        move = randChoice(lowestColumns)
        makeMove(move)

      evalColorSpace: ->
        for col in [0...Tetromino.info.cols]
          if columnTopBlock(col).color == Tetromino.get_active_block().color
            return col
        return -1

      randChoice: (arr) ->
        return arr[Math.floor(Math.random() * arr.length)]

      lowestColumns: ->
        # return the columns with the least block build-up
        lowestX = Tetromino.info.rows
        cols = []
        for col in [0...Tetromino.info.cols]
          top = columnTopBlock(col)
          if top
            if lowestX > top.x
              cols = []
              cols.push col
            else
              if lowestX == top.x
                cols.push col
          else
            # This ensures that if the column is empty it is given priority
            if lowestX != Tetromino.info.rows-1
              cols = []
            cols.push col
        return cols

      columnTopBlock: (colNum) ->
        topBlock = null
        for x in [0...Tetromino.info.rows]
          block = getSpecBlock(x, colNum)
          if block && block.locked
            if topBlock
              if block.x < topBlock.x
                topBlock = block
            else
              topBlock == block
        return topBlock

      getSpecBlock: (x,y) ->
        return Tetromino.blocks.filter (b) -> b.x == x && b.y == y

    new AiChoice()
  ]
