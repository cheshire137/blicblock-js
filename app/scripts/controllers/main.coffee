'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'MainCtrl', ['$scope', '$window', '$interval', 'Tetromino', ($scope, $window, $interval, Tetromino) ->
    $scope.blocks = Tetromino.blocks
    $scope.upcoming = []
    $scope.game_info = Tetromino.info
    game_interval = undefined
    colors = ['magenta', 'yellow', 'blue', 'green', 'white', 'orange']

    get_color = ->
      colors[Math.floor(Math.random() * colors.length)]

    cancel_game_interval = ->
      if angular.isDefined(game_interval)
        $interval.cancel game_interval
        game_interval = undefined

    game_over = ->
      $scope.game_info.in_progress = false
      $scope.game_info.game_over = true
      cancel_game_interval()

    queue_block = ->
      $scope.upcoming[1] = new Block
        color: get_color()

    drop_queued_block = ->
      return if $scope.game_info.checking
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
      active_block = Tetromino.get_active_block()
      return if active_block
      drop_queued_block()

    game_loop = ->
      return unless $scope.game_info.in_progress
      Tetromino.drop_blocks()
      drop_queued_block_if_no_active()

    start_game_interval = ->
      return if angular.isDefined(game_interval)
      game_interval = $interval(game_loop, $scope.game_info.tick_length)

    $scope.upcoming.push new Block
      color: get_color()
    $scope.upcoming.push new Block
      color: get_color()

    $scope.$on 'pause', (event) ->
      $scope.game_info.in_progress = false
      cancel_game_interval()

    $scope.$on 'resume', (event) ->
      $scope.game_info.in_progress = true
      start_game_interval()

    $scope.$on 'move_left', (event) ->
      block = Tetromino.get_active_block()
      return unless block
      return if block.y == 0
      block.sliding = true
      block_to_left = Tetromino.get_closest_block_to_left(block.x, block.y)
      if block_to_left
        block.y = block_to_left.y + 1
      else
        block.y--
      block.sliding = false

    $scope.$on 'move_right', (event) ->
      block = Tetromino.get_active_block()
      return unless block
      return if block.y == $scope.game_info.cols - 1
      block.sliding = true
      block_to_right = Tetromino.get_closest_block_to_right(block.x, block.y)
      if block_to_right
        block.y = block_to_right.y - 1
      else
        block.y++
      block.sliding = false

    $scope.$on 'move_down', (event) ->
      block = Tetromino.get_active_block()
      return unless block
      return if block.x == $scope.game_info.rows - 1
      block_below = Tetromino.get_closest_block_below(block.x, block.y)
      if block_below
        block.x = block_below.x - 1
      else
        block.x = $scope.game_info.rows - 1
      block.locked = true
      block.active = false
      Tetromino.on_block_land block
      cancel_game_interval()
      drop_queued_block()
      start_game_interval()

    $scope.$watch 'game_info.level', ->
      if $scope.game_info.level > 1
        $scope.game_info.tick_length -=
            $scope.game_info.tick_length *
            $scope.game_info.tick_length_decrement_pct
        cancel_game_interval()
      start_game_interval()

    $scope.new_game = ->
      $window.location.reload();

    $scope.$on '$locationChangeStart', (event) ->
      $scope.$emit('pause')
  ]
