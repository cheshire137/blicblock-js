'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'MainCtrl', ['$scope', '$window', '$interval', 'localStorageService', 'Tetromino', ($scope, $window, $interval, localStorageService, Tetromino) ->
    $scope.blocks = Tetromino.blocks
    $scope.upcoming = []
    $scope.game_info = Tetromino.info
    $scope.new_high_score = {}
    game_interval = undefined
    colors = ['magenta', 'yellow', 'blue', 'green', 'white', 'orange']
    high_score_storage_key = 'high_score'

    get_existing_high_score = ->
      high_score = localStorageService.get(high_score_storage_key)
      return high_score if high_score
      {}

    $scope.existing_high_score = get_existing_high_score()

    get_color = ->
      colors[Math.floor(Math.random() * colors.length)]

    cancel_game_interval = ->
      if angular.isDefined(game_interval)
        $interval.cancel game_interval
        game_interval = undefined

    save_high_score = ->
      high_score = localStorageService.get(high_score_storage_key)
      current_score = $scope.game_info.current_score
      if high_score && high_score.value < current_score || !high_score
        high_score =
          value: current_score
          date: new Date()
        localStorageService.set(high_score_storage_key, high_score)
        $scope.new_high_score.value = high_score.value

    game_over = ->
      $scope.game_info.in_progress = false
      $scope.game_info.game_over = true
      cancel_game_interval()
      save_high_score()

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
      return if $scope.game_info.plumetting_block
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

    $scope.$on 'toggle_pause', (event) ->
      if $scope.game_info.in_progress
        $scope.$emit('pause')
      else if !$scope.game_info.game_over
        $scope.$emit('resume')

    $scope.$on 'move_left', (event) ->
      return unless $scope.game_info.in_progress
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
      return unless $scope.game_info.in_progress
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
      return unless $scope.game_info.in_progress
      block = Tetromino.get_active_block()
      return unless block
      return if block.x == $scope.game_info.rows - 1
      block_below = Tetromino.get_closest_block_below(block.x, block.y)
      if block_below
        new_x = block_below.x - 1
      else
        new_x = $scope.game_info.rows - 1
      drop_single_block_interval = undefined
      drop_single_block = ->
        $scope.game_info.plumetting_block = true
        if block.x < new_x
          block.x++
        else if block.x == new_x
          $interval.cancel drop_single_block_interval
          drop_single_block_interval = undefined
          block.locked = true
          block.active = false
          $scope.game_info.plumetting_block = false
          Tetromino.on_block_land block
          cancel_game_interval()
          drop_queued_block()
          start_game_interval()
      drop_single_block_interval = $interval(drop_single_block, 25)

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
