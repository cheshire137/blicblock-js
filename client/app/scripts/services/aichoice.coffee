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
       for col in [move..2]
          top = @getSpecBlock(0,col)
          if top && top.locked
            return false
        return true

      makeChoice: ->
        if Tetromino.get_active_block()
          move = @evalColorSpace()
          if move != -1 && @canMove(move)
            @makeMove(move)
          else
            move = @randChoice(@lowestColumns())
            @makeMove(move)

      evalColorSpace: ->
        lowestX = Tetromino.info.rows
        choice = -1
        for col in [0...Tetromino.info.cols]
          topBlock = @columnTopBlock(col)
          if topBlock && @canMove(col)
            if topBlock.color == Tetromino.get_active_block().color
              if topBlock.x < lowestX
                choice = col
        return choice

      randChoice: (arr) ->
        if arr.length != 0
          return arr[Math.floor(Math.random() * arr.length)]
        else
          return 2

      lowestColumns: ->
        # return the columns with the least block build-up
        highestX = 0
        cols = []
        for col in [0...Tetromino.info.cols]
          top = @columnTopBlock(col)
          if top && @canMove(col)
            if highestX < top.x-1
              cols = []
              highestX = top.x-1
              cols.push col
            else
              if highestX == top.x-1
                cols.push col
          else
            if @canMove(col)
              # This ensures that if the column is empty it is given priority
              if highestX != Tetromino.info.rows-1
                cols = []
                highestX = Tetromino.info.rows-1
              cols.push col
        newCols = []
        for col in cols
          top = @columnTopBlock(col)
          if top
            color = top.color
            if color != Tetromino.upcoming[0].color
              if color != Tetromino.upcoming[1].color
                newCols.push col
        if newCols.length > 0
          cols = newCols
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
