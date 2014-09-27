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
          checking: false
          in_progress: true
          game_over: false
          current_score: 0
          tick_length_increment: 100 # ms
          tick_length: 1200 # ms
          level: 1

      get_active_block: ->
        @blocks.filter((b) -> b.active)[0]

      check_for_tetrominos: ->
        return unless @info.in_progress
        return if @info.checking
        @info.checking = true
        for block in @blocks
          continue unless block
          @check_for_straight_tetromino block
          @check_for_square_tetromino block
          @check_for_l_tetromino block
          @check_for_z_tetromino block
          @check_for_t_tetromino block
        @info.checking = false

      get_closest_block_to_left: (x, y) ->
        blocks_to_left = @blocks.filter((b) -> b.x == x && b.y < y)
        blocks_to_left.sort (a, b) ->
          return -1 if a.y < b.y
          return 1 if a.y > b.y
          0
        blocks_to_left[blocks_to_left.length - 1]

      get_closest_block_to_right: (x, y) ->
        blocks_to_right = @blocks.filter((b) -> b.x == x && b.y > y)
        blocks_to_right.sort (a, b) ->
          return -1 if a.y < b.y
          return 1 if a.y > b.y
          0
        blocks_to_right[0]

      get_closest_block_below: (x, y) ->
        blocks_below = @blocks.filter((b) -> b.x > x && b.y == y)
        blocks_below.sort (a, b) ->
          return -1 if a.x < b.x
          return 1 if a.x > b.x
          0
        blocks_below[0]

      is_block_directly_below: (x, y) ->
        @blocks.filter((b) -> b.x == x + 1 && b.y == y)[0]

      drop_blocks: ->
        return unless @info.in_progress
        for block in @blocks
          continue unless block
          if block.x == @info.rows - 1
            block.locked = true
            block.active = false
            @on_block_land block
          if @is_block_directly_below(block.x, block.y)
            block.locked = true
            block.active = false
            @on_block_land block
          else if block.locked && !block.active && block.x < @info.rows - 1
            # A match was made that removed blocks under this one, so drop
            # this one as far as it will go immediately.
            block_below = @get_closest_block_below(block.x, block.y)
            if block_below
              block.x = block_below.x - 1
            else
              block.x = @info.rows - 1
          continue if block.locked
          block.x++

      on_block_land: (block) ->
        @check_for_tetrominos()

      increment_level_if_necessary: ->
        if @info.current_score % 4000 == 0
          @info.level++

      remove_blocks: (to_remove) ->
        return unless @info.in_progress
        ids_to_remove = to_remove.map((b) -> b.id)
        idx = @blocks.length - 1
        while idx >= 0
          if ids_to_remove.indexOf(@blocks[idx].id) > -1
            @blocks.splice(idx, 1)
          idx--
        @info.current_score += @info.score_value
        @increment_level_if_necessary()
        @drop_blocks()
        @check_for_tetrominos()

      lookup: (x, y, color) ->
        return if x >= @info.rows
        return if y >= @info.cols
        @blocks.filter((b) -> b.x == x && b.y == y && b.color == color)[0]

      check_for_straight_tetromino: (block1) ->
        @check_for_straight_hor_tetromino block1
        @check_for_straight_ver_tetromino block1

      # 1***
      check_for_straight_hor_tetromino: (block1) ->
        y = block1.y
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
        y = block1.y
        color = block1.color
        block2 = @lookup(x + 1, y, color)
        return unless block2
        block3 = @lookup(x + 2, y, color)
        return unless block3
        block4 = @lookup(x + 3, y, color)
        return unless block4
        @remove_blocks [block1, block2, block3, block4]

      # 1*
      # **
      check_for_square_tetromino: (block1) ->
        x = block1.x
        y = block1.y
        color = block1.color
        block2 = @lookup(x, y + 1, color)
        return unless block2
        block3 = @lookup(x + 1, y, color)
        return unless block3
        block4 = @lookup(x + 1, y + 1, color)
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
          else # C
            block4 = @lookup(x, y + 1, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]
        else # B or D
          block3 = @lookup(x + 1, y + 1, color)
          if block3 # B
            block4 = @lookup(x + 1, y + 2, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]
          else # D
            block3 = @lookup(x, y - 1, color)
            return unless block3
            block4 = @lookup(x, y - 2, color)
            return unless block4
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
          else # C
            block4 = @lookup(x, y - 1, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]
        else # B or D
          block3 = @lookup(x + 1, y - 1, color)
          if block3 # B
            block4 = @lookup(x + 1, y - 2, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]
          else # D
            block3 = @lookup(x, y + 1, color)
            return unless block3
            block4 = @lookup(x, y + 2, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]

      #           1    1
      # *1    1*  **  **
      #  **  **    *  *
      #  A   B    C   D
      check_for_z_tetromino: (block1) ->
        x = block1.x
        y = block1.y
        color = block1.color
        block2 = @lookup(x + 1, y, color)
        return unless block2
        block3 = @lookup(x, y - 1, color)
        if block3 # A
          block4 = @lookup(x + 1, y + 1, color)
          return unless block4
          @remove_blocks [block1, block2, block3, block4]
        else # B, C, or D
          block3 = @lookup(x, y + 1, color)
          if block3 # B
            block4 = @lookup(x + 1, y - 1, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]
          else # C or D
            block3 = @lookup(x + 1, y + 1, color)
            if block3 # C
              block4 = @lookup(x + 2, y + 1, color)
              return unless block4
              @remove_blocks [block1, block2, block3, block4]
            else # D
              block3 = @lookup(x + 1, y - 1, color)
              return unless block3
              block4 = @lookup(x + 2, y - 1, color)
              return unless block4
              @remove_blocks [block1, block2, block3, block4]

      # 1    1
      # **  **   1   *1*
      # *    *  ***   *
      # A    B   C    D
      check_for_t_tetromino: (block1) ->
        x = block1.x
        y = block1.y
        color = block1.color
        block2 = @lookup(x + 1, y, color)
        return unless block2
        block3 = @lookup(x + 2, y, color)
        if block3 # A or B
          block4 = @lookup(x + 1, y + 1, color)
          if block4 # A
            @remove_blocks [block1, block2, block3, block4]
          else # B
            block4 = @lookup(x + 1, y - 1, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]
        else # C or D
          block3 = @lookup(x + 1, y - 1, color)
          if block3 # C
            block4 = @lookup(x + 1, y + 1, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]
          else # D
            block3 = @lookup(x, y - 1, color)
            return unless block3
            block4 = @lookup(x, y + 1, color)
            return unless block4
            @remove_blocks [block1, block2, block3, block4]

    new Tetromino()
  ]
