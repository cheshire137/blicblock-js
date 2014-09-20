'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.tetromino
 # @description
 # # tetromino
 # Service in the blicblockApp.
###
angular.module('blicblockApp')
  .service 'Tetromino', ['$rootScope', ($rootScope) ->
    class Tetromino
      constructor: ->
        @blocks = []
        @info =
          cols: 5
          rows: 7
          score_value: 1000

      check_for_tetrominos: ->
        for block in @blocks
          @check_for_straight_tetromino block
          @check_for_l_tetromino block

      remove_blocks: (to_remove) ->
        ids_to_remove = to_remove.map((b) -> b.id)
        idx = @blocks.length - 1
        while idx >= 0
          if ids_to_remove.indexOf(@blocks[idx].id) > -1
            @blocks.splice(idx, 1)
          idx--
        $rootScope.$broadcast 'increment_score', {amount: @info.score_value}
        @check_for_tetrominos()

      lookup: (x, y, color) ->
        @blocks.filter((b) -> b.x == x && b.y == y && b.color == color)[0]

      check_for_straight_tetromino: (block1) ->
        @check_for_straight_hor_tetromino block1
        @check_for_straight_ver_tetromino block1

      # 1***
      check_for_straight_hor_tetromino: (block1) ->
        y = block1.y
        return if y >= @info.cols - 3
        x = block1.x
        color = block1.color
        block2 = @lookup(x, y + 1, color)
        return unless block2
        block3 = @lookup(x, y + 2, color)
        return unless block3
        block4 = @lookup(x, y + 3, color)
        return unless block4
        @remove_blocks [block1, block2, block3, block4]

      # 1
      # *
      # *
      # *
      check_for_straight_ver_tetromino: (block1) ->
        x = block1.x
        return if x >= @info.rows - 3
        y = block1.y
        color = block1.color
        block2 = @lookup(x + 1, y, color)
        return unless block2
        block3 = @lookup(x + 2, y, color)
        return unless block3
        block4 = @lookup(x + 3, y, color)
        return unless block4
        @remove_blocks [block1, block2, block3, block4]

      check_for_l_tetromino: (block1) ->
        @check_for_left_l_tetromino block1
        @check_for_right_l_tetromino block1

      #  1       1*
      #  *  1    *   **1
      # **  ***  *     *
      # A   B    C   D
      check_for_left_l_tetromino: (block1) ->
        x = block1.x
        y = block1.y
        color = block1.color
        block2 = @lookup(x + 1, y, color)
        return unless block2
        block3 = @lookup(x + 2, y, color)
        if block3 # A or C
          block4 = @lookup(x + 2, y - 1, color)
          if block4 # A
            @remove_blocks [block1, block2, block3, block4]
          else
            block4 = @lookup(x, y + 1, color)
            if block4 # C
              @remove_blocks [block1, block2, block3, block4]
        else # B or D
          block3 = @lookup(x + 1, y + 1, color)
          if block3 # B
            block4 = @lookup(x + 1, y + 2, color)
            if block4
              @remove_blocks [block1, block2, block3, block4]
          else # D
            block3 = @lookup(x, y - 1, color)
            if block3
              block4 = @lookup(x, y - 2, color)
              if block4
                @remove_blocks [block1, block2, block3, block4]

      # 1        *1
      # *     1   *  1**
      # **  ***   *  *
      # A   B     C  D
      check_for_right_l_tetromino: (block1) ->
        x = block1.x
        y = block1.y
        color = block1.color
        block2 = @lookup(x + 1, y, color)
        return unless block2
        block3 = @lookup(x + 2, y, color)
        if block3 # A or C
          block4 = @lookup(x + 2, y + 1, color)
          if block4 # A
            @remove_blocks [block1, block2, block3, block4]
          else
            block4 = @lookup(x, y - 1, color)
            if block4 # C
              @remove_blocks [block1, block2, block3, block4]
        else # B or D
          block3 = @lookup(x + 1, y - 1, color)
          if block3 # B
            block4 = @lookup(x + 1, y - 2, color)
            if block4
              @remove_blocks [block1, block2, block3, block4]
          else # D
            block3 = @lookup(x, y + 1, color)
            if block3
              block4 = @lookup(x, y + 2, color)
              if block4
                @remove_blocks [block1, block2, block3, block4]

    new Tetromino()
  ]
