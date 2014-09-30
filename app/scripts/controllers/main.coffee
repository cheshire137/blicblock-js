'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'MainCtrl', ['$scope', '$window', '$timeout', '$interval', 'localStorageService', 'Tetromino', ($scope, $window, $timeout, $interval, localStorageService, Tetromino) ->
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
      middle_col_blocks = Tetromino.get_middle_column_blocks()
      if middle_col_blocks.length < $scope.game_info.rows
        x = 0 # At the top
        y = $scope.game_info.middle_col_idx # Centered horizontally
        top_mid_block = $scope.blocks.filter((b) -> b.x == x && b.y == y)[0]
        if top_mid_block
          # Currently dropping or sliding at the top
          return
        block = $scope.upcoming[0]
        block.x = x
        block.y = y
        $scope.upcoming[0] = $scope.upcoming[1]
        queue_block()
        $scope.blocks.push block
      else
        game_over()

    drop_queued_block_if_no_active = ->
      active_block = Tetromino.get_active_block()
      return if active_block
      drop_queued_block()

    game_loop = ->
      return unless $scope.game_info.in_progress
      return if $scope.game_info.plumetting_block
      return if $scope.game_info.sliding_block
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
      return if $scope.game_info.plumetting_block
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

    stop_sliding = (block) ->
      block.sliding = false
      $scope.game_info.sliding_block = false

    $scope.$on 'move_left', (event) ->
      return unless $scope.game_info.in_progress
      block = Tetromino.get_active_block()
      return unless block
      return if block.plumetting || block.sliding
      return if block.y == 0
      block.sliding = true
      $scope.game_info.sliding_block = true
      block_to_left = Tetromino.get_closest_block_to_left(block.x, block.y)
      if block_to_left
        block.y = block_to_left.y + 1
      else
        block.y--
      $timeout (-> stop_sliding(block)), 150

    $scope.$on 'move_right', (event) ->
      return unless $scope.game_info.in_progress
      block = Tetromino.get_active_block()
      return unless block
      return if block.plumetting || block.sliding
      return if block.y == $scope.game_info.cols - 1
      block.sliding = true
      $scope.game_info.sliding_block = true
      block_to_right = Tetromino.get_closest_block_to_right(block.x, block.y)
      if block_to_right
        block.y = block_to_right.y - 1
      else
        block.y++
      $timeout (-> stop_sliding(block)), 150

    $scope.$on 'move_down', (event) ->
      return unless $scope.game_info.in_progress
      block = Tetromino.get_active_block()
      return unless block
      return if block.plumetting || block.sliding
      return if block.x == $scope.game_info.rows - 1
      block_below = Tetromino.get_closest_block_below(block.x, block.y)
      if block_below
        new_x = block_below.x - 1
      else
        new_x = $scope.game_info.rows - 1
      Tetromino.plummet_block block, new_x, ->
        cancel_game_interval()
        drop_queued_block_if_no_active()
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
