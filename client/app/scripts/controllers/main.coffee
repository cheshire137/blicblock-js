'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'MainCtrl', ['$scope', '$window', '$timeout', '$interval', '$routeParams', '$rootScope', 'localStorageService', 'Config', 'Tetromino', 'Score', 'Notification', 'AiChoice', ($scope, $window, $timeout, $interval, $routeParams, $rootScope, localStorageService, Config, Tetromino, Score, Notification, AiChoice) ->
    $scope.blocks = Tetromino.blocks
    $scope.upcoming = Tetromino.upcoming
    $scope.game_info = Tetromino.info
    $scope.made_choice = false
    $scope.use_ai = false
    $scope.score_record = new Score()
    $scope.new_high_score = {}
    game_interval = undefined

    $scope.new_game = ->
      $scope.score_record = new Score()
      $window.location.reload()

    if $routeParams.ai_count
      $scope.use_ai = true

    if $routeParams.color_count
      color_count = parseInt($routeParams.color_count, 10)
      if color_count > Tetromino.colors.length
        color_count = Tetromino.colors.length - 1
      color_count = 1 if color_count < 1
      colors = Tetromino.colors.slice(0, color_count)
    else
      colors = Tetromino.colors
      $scope.new_game() if $scope.game_info.test_mode

    get_color = ->
      colors[Math.floor(Math.random() * colors.length)]

    if $routeParams.cascade_count
      cascade_count = parseInt($routeParams.cascade_count, 10)
      switch cascade_count
        when 1 then Tetromino.setup_one_cascade()
        when 2 then Tetromino.setup_two_cascades()
        when 3 then Tetromino.setup_three_cascades()
        else Tetromino.setup_four_cascades()
      $scope.upcoming.push new Block
        color: get_color()
    else
      $scope.new_game() if $scope.game_info.test_mode
      while $scope.upcoming.length < 2
        $scope.upcoming.push new Block
          color: get_color()

    $scope.game_info.test_mode = !!$routeParams.color_count ||
                                 !!$routeParams.cascade_count

    get_existing_high_score = ->
      if $scope.game_info.test_mode
        value: -1000000
        date: new Date(1969, 0, 1)
      else
        high_score = localStorageService.get(Config.storage_keys.high_score)
        return high_score if high_score
        {}

    $scope.existing_high_score = get_existing_high_score()

    cancel_game_interval = ->
      if angular.isDefined(game_interval)
        $interval.cancel game_interval
        game_interval = undefined

    save_high_score = ->
      return if $scope.game_info.test_mode
      high_score = localStorageService.get(Config.storage_keys.high_score)
      current_score = $scope.game_info.current_score
      $scope.score_record.value = current_score
      $scope.score_record.initials =
          localStorageService.get(Config.storage_keys.initials)
      if high_score && high_score.value < current_score || !high_score
        high_score =
          value: current_score
          date: new Date()
        localStorageService.set(Config.storage_keys.high_score, high_score)
        $scope.new_high_score.value = high_score.value

    $scope.record_high_score = ->
      return if $scope.game_info.test_mode
      on_success = (data) ->
        Notification.notice("You are ##{data.rank} out of " +
                            "#{data.total_scores} scores!")
        $scope.game_info.submitted_score = true
        localStorageService.set(Config.storage_keys.initials, data.initials)
      on_error = (response) ->
        Notification.error 'Failed to record your score: ' + response.data.error
      $scope.score_record.$save on_success, on_error

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
      $scope.made_choice = false # new block new choice
      drop_queued_block()

    game_loop = ->
      return unless $scope.game_info.in_progress
      return if $scope.game_info.plummetting_block
      return if $scope.game_info.sliding_block
      if $scope.use_ai && !$scope.made_choice
        AiChoice.makeChoice()
        $scope.made_choice = true
      Tetromino.drop_blocks()
      drop_queued_block_if_no_active()

    start_game_interval = ->
      return if angular.isDefined(game_interval)
      game_interval = $interval(game_loop, $scope.game_info.tick_length)

    $scope.$on 'pause', (event) ->
      return if $scope.game_info.plummetting_block
      $scope.game_info.in_progress = false
      cancel_game_interval()

    $scope.$on 'resume', (event) ->
      return if $scope.game_info.game_over
      $scope.game_info.in_progress = true
      start_game_interval()

    $scope.$on 'toggle_pause', (event) ->
      if $scope.game_info.in_progress
        $scope.$emit('pause')
      else
        $scope.$emit('resume')

    stop_sliding = (block) ->
      block.sliding = false
      $scope.game_info.sliding_block = false

    $scope.$on 'move_left', (event) ->
      return unless $scope.game_info.in_progress
      block = Tetromino.get_active_block()
      return unless block
      return if block.plummetting || block.sliding
      return if block.y == 0
      block.sliding = true
      $scope.game_info.sliding_block = true
      block_to_left = Tetromino.get_closest_block_to_left(block.x, block.y)
      if block_to_left && block_to_left.y == block.y - 1
        stop_sliding(block)
        return
      block.y--
      $timeout (-> stop_sliding(block)), 100

    $scope.$on 'move_right', (event) ->
      return unless $scope.game_info.in_progress
      block = Tetromino.get_active_block()
      return unless block
      return if block.plummetting || block.sliding
      return if block.y == $scope.game_info.cols - 1
      block.sliding = true
      $scope.game_info.sliding_block = true
      block_to_right = Tetromino.get_closest_block_to_right(block.x, block.y)
      if block_to_right && block_to_right.y == block.y + 1
        stop_sliding(block)
        return
      block.y++
      $timeout (-> stop_sliding(block)), 100

    $scope.$on 'move_down', (event) ->
      return unless $scope.game_info.in_progress
      block = Tetromino.get_active_block()
      return unless block
      return if block.plummetting || block.sliding
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

    $scope.$on '$locationChangeStart', (event) ->
      $scope.$emit('pause')

    $rootScope.$watch 'collapse.nav', ->
      unless $rootScope.collapse.nav
        $scope.$emit('pause')

    $scope.capitalize_initials = ->
      return unless $scope.score_record.initials
      $scope.score_record.initials = $scope.score_record.initials.toUpperCase()
  ]
