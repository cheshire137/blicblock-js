'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.aichoice
 # @description
 # # aichoice
 # Service in the blicblockApp.
###
angular.module('blicblockApp')
  .service 'AiChoice', ['$rootScope', '$interval', '$timeout', 'Tetromino', ($rootScope, $interval, $timeout, Tetromino) ->
    class AiChoice
      makeMove: (move) ->
        Tetromino.get_active_block().y = move

      canMove: (move) ->
        top = @columnTopBlock(move)
        if top && top.x == 0
          return false
        return true

      makeChoice: ->
        if Tetromino.get_active_block()
          move = @evalColorSpace()
          if move != -1 && @canMove(move)
            @makeMove(move)
          else
            move = @randChoice(@lowestColumns())
            while !@canMove(move)
              move = @randChoice(@lowestColumns())
            @makeMove(move)

      evalColorSpace: ->
        for col in [0...Tetromino.info.cols]
          topBlock = @columnTopBlock(col)
          if topBlock
            if topBlock.color == Tetromino.get_active_block().color
              return col
        return -1

      randChoice: (arr) ->
        return arr[Math.floor(Math.random() * arr.length)]

      lowestColumns: ->
        # return the columns with the least block build-up
        highestX = 0
        cols = []
        for col in [0...Tetromino.info.cols]
          top = @columnTopBlock(col)
          if top
            if highestX < top.x-1
              cols = []
              highestX = top.x-1
              cols.push col
            else
              if highestX == top.x-1
                cols.push col
          else
            # This ensures that if the column is empty it is given priority
            if highestX != Tetromino.info.rows-1
              cols = []
              highestX = Tetromino.info.rows-1

            cols.push col
        return cols

      columnTopBlock: (colNum) ->
        topBlock = null
        for x in [0...Tetromino.info.rows]
          block = @getSpecBlock(x, colNum)
          if block && block.locked
            if topBlock
              if block.x < topBlock.x
                topBlock = block
            else
              topBlock = block
        return topBlock

      getSpecBlock: (x,y) ->
        return (Tetromino.blocks.filter (b) -> b.x == x && b.y == y)[0]

    new AiChoice()
  ]
