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

    get_color = ->
      colors[Math.floor(Math.random() * colors.length)]

    game_over = ->
      $scope.game_state.in_progress = false
      $interval.cancel game_interval

    drop_unlocked_blocks = ->
      for block in $scope.blocks
        if block.x == rows - 1
          block.locked = true
          block.active = false
        blocks_below = $scope.blocks.filter (b) ->
          b.x == block.x + 1 && b.y == block.y
        if blocks_below[0]
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
      active_block = $scope.blocks.filter((b) -> b.active)[0]
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
  ]
