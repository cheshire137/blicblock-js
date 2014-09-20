'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'MainCtrl', ['$scope', '$interval', 'Tetromino', ($scope, $interval, Tetromino) ->
    $scope.blocks = Tetromino.blocks
    $scope.upcoming = []
    $scope.game_state =
      in_progress: true
      score: 0
      checking: false
    $scope.game_info = Tetromino.info

    game_interval = null

    colors = ['magenta', 'yellow', 'blue', 'green']
    tick_length = 1150 # ms

    on_block_land = (block) ->
      $scope.game_state.checking = true
      Tetromino.check_for_tetrominos()
      $scope.game_state.checking = false

    get_active_block = ->
      $scope.blocks.filter((b) -> b.active)[0]

    get_color = ->
      colors[Math.floor(Math.random() * colors.length)]

    game_over = ->
      $scope.game_state.in_progress = false
      $interval.cancel game_interval

    get_closest_block_below = (x, y) ->
      blocks = $scope.blocks.filter((b) -> b.x > x && b.y == y)
      blocks.sort (a, b) ->
        return -1 if a.x < b.x
        return 1 if a.x > b.x
        0
      blocks[0]

    is_block_directly_below = (x, y) ->
      $scope.blocks.filter((b) -> b.x == x + 1 && b.y == y)[0]

    drop_unlocked_blocks = ->
      for block in $scope.blocks
        if block.x == $scope.game_info.rows - 1
          block.locked = true
          block.active = false
          on_block_land block
        if is_block_directly_below(block.x, block.y)
          block.locked = true
          block.active = false
          on_block_land block
        continue if block.locked
        block.x++

    queue_block = ->
      $scope.upcoming[1] = new Block
        color: get_color()

    drop_queued_block = ->
      return if $scope.game_state.checking
      top_blocks = $scope.blocks.filter (b) ->
        b.x == 0 && b.y == 2
      if top_blocks.length > 0
        game_over()
        return
      block = $scope.upcoming[0]
      block.x = 0 # At the top
      block.y = 2 # Centered horizontally
      $scope.upcoming[0] = $scope.upcoming[1]
      queue_block()
      $scope.blocks.push block

    drop_queued_block_if_no_active = ->
      active_block = get_active_block()
      return if active_block
      drop_queued_block()

    game_loop = ->
      drop_unlocked_blocks()
      drop_queued_block_if_no_active()

    $scope.upcoming.push new Block
      color: get_color()
    $scope.upcoming.push new Block
      color: get_color()

    game_interval = $interval(game_loop, tick_length)

    $scope.$on 'move_left', (event) ->
      block = get_active_block()
      return unless block
      return if block.y == 0
      block.y--

    $scope.$on 'move_right', (event) ->
      block = get_active_block()
      return unless block
      return if block.y == $scope.game_info.cols - 1
      block.y++

    $scope.$on 'move_down', (event) ->
      block = get_active_block()
      return unless block
      return if block.x == $scope.game_info.rows - 1
      block_below = get_closest_block_below(block.x, block.y)
      if block_below
        block.x = block_below.x - 1
      else
        block.x = $scope.game_info.rows - 1
      block.locked = true
      block.active = false
      on_block_land block

    $scope.$on 'increment_score', (event, args) ->
      $scope.game_state.score += args.amount
  ]
