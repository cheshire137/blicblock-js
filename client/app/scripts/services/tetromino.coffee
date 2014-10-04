'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.tetromino
 # @description
 # # tetromino
 # Service in the blicblockApp.
###
angular.module('blicblockApp')
  .service 'Tetromino', ['$rootScope', '$interval', '$timeout', ($rootScope, $interval, $timeout) ->
    class Tetromino
      constructor: ->
        @blocks = []
        @upcoming = []
        @colors = ['magenta', 'orange', 'yellow', 'green', 'blue', 'white']
        @info =
          cols: 5
          rows: 7
          score_value: 1000
          checking: false
          in_progress: true
          plummetting_block: false
          sliding_block: false
          game_over: false
          current_score: 0
          tick_length_decrement_pct: 0.09
          tick_length: 1200 # ms
          level: 1
          test_mode: false
          submitted_score: false
        @info.middle_col_idx = (@info.cols - 1) / 2

      remove_all_blocks: ->
        idx = @blocks.length - 1
        while idx >= 0
          @blocks.splice(idx, 1)
          idx--

      setup_cascade: ->
        @info.in_progress = false
        @remove_all_blocks()

      setup_one_cascade: ->
        @setup_cascade()
        last_row_x = @info.rows - 1
        color1 = @colors[0]
        color2 = @colors[1]
        @blocks.push new Block
          color: color1
          x: last_row_x
          y: 0
          locked: true
          active: false
        @blocks.push new Block
          color: color1
          x: last_row_x
          y: 1
          locked: true
          active: false
        @blocks.push new Block
          color: color1
          x: last_row_x
          y: 2
          locked: true
          active: false
        @blocks.push new Block
          color: color2
          x: last_row_x - 1
          y: 0
          locked: true
          active: false
        @blocks.push new Block
          color: color2
          x: last_row_x - 2
          y: 0
          locked: true
          active: false
        @blocks.push new Block
          color: color2
          x: last_row_x - 3
          y: 0
          locked: true
          active: false
        @blocks.push new Block
          color: color1
          x: last_row_x - 4
          y: 0
          locked: true
          active: false
        @upcoming[0] = new Block
          color: color2
        @info.in_progress = true

      setup_two_cascades: ->
        @setup_cascade()

      setup_three_cascades: ->
        @setup_cascade()

      setup_four_cascades: ->
        @setup_cascade()

      get_active_block: ->
        @blocks.filter((b) -> b.active)[0]

      get_middle_column_blocks: ->
        @blocks.filter((b) => b.y == @info.middle_col_idx)

      check_for_tetrominos: ->
        return unless @info.in_progress
        return if @info.checking
        @info.checking = true
        for block in @blocks
          continue unless block && block.locked && !block.active
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

      # Animate dropping the given block to the given x coordinate.
      plummet_block: (block, x, on_land_callback) ->
        drop_single_block_interval = undefined
        drop_single_block = =>
          block.plummetting = true
          @info.plummetting_block = true
          if block.x < x
            block.x++
          else if block.x == x
            $interval.cancel drop_single_block_interval
            drop_single_block_interval = undefined
            block.locked = true
            block.active = false
            @info.plummetting_block = false
            block.plummetting = false
            @on_block_land block
            on_land_callback() if on_land_callback
        drop_single_block()
        drop_single_block_interval = $interval(drop_single_block, 25)

      # Returns an array of blocks anywhere over top of the given blocks
      blocks_on_top: (blocks) ->
        x_coords = (b.x for b in blocks)
        y_coords = (b.y for b in blocks)
        max_x = Math.max(x_coords...)
        on_top = @blocks.filter (b) -> b.x < max_x && y_coords.indexOf(b.y) > -1
        on_top.sort (a, b) -> # Closest to bottom first
          return 1 if a.x < b.x
          return -1 if a.x > b.x
          0
        on_top

      highlight: (block) ->
        block.highlight = true
        $timeout (-> block.highlight = false), @info.tick_length * 0.21

      drop_blocks: ->
        return unless @info.in_progress
        for block in @blocks
          continue unless block
          continue if block.sliding
          active_or_not_locked = block.active || !block.locked
          if block.x == @info.rows - 1 && active_or_not_locked
            block.locked = true
            block.active = false
            @on_block_land block
          if @is_block_directly_below(block.x, block.y) && active_or_not_locked
            block.locked = true
            block.active = false
            @on_block_land block
          continue if block.locked
          block.x++

      on_block_land: (block) ->
        @highlight block
        @check_for_tetrominos()

      increment_level_if_necessary: ->
        if @info.current_score % 4000 == 0
          @info.level++

      plummet_blocks: (blocks, idx) ->
        idx = 0 if typeof idx == 'undefined'
        block = blocks[idx]
        block_below = @get_closest_block_below(block.x, block.y)
        new_x = if block_below then block_below.x - 1 else @info.rows - 1
        @plummet_block block, new_x, =>
          @plummet_blocks(blocks, idx + 1) if idx < blocks.length - 1

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
        on_top = @blocks_on_top(to_remove)
        on_top = on_top.filter((b) -> !b.active)
        @plummet_blocks(on_top) if on_top.length > 0
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
