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
      makeMove: ->
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

      randChoice: ->
      lowestColumns: ->

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
