'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'MainCtrl', ['$scope', '$interval', ($scope, $interval) ->
    $scope.blocks = []
    $scope.upcoming = []
    $scope.game_state =
      in_progress: true

    game_interval = null

    colors = ['magenta', 'yellow', 'blue', 'green']
    rows = 7
    cols = 5
    tick_length = 1200 # ms

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
        if block.x == rows - 1
          block.locked = true
          block.active = false
        if is_block_directly_below(block.x, block.y)
          block.locked = true
          block.active = false
        continue if block.locked
        block.x++

    queue_block = ->
      $scope.upcoming[1] = new Block
        color: get_color()

    drop_queued_block = ->
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
      return if block.y == cols - 1
      block.y++

    $scope.$on 'move_down', (event) ->
      block = get_active_block()
      return unless block
      return if block.x == rows - 1
      block_below = get_closest_block_below(block.x, block.y)
      if block_below
        block.x = block_below.x - 1
      else
        block.x = rows - 1
      block.locked = true
      block.active = false
      game_loop()
  ]
