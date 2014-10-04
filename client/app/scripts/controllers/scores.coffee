'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:ScoresCtrl
 # @description
 # # ScoresCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'ScoresCtrl', ['$scope', 'Score', ($scope, Score) ->
    $scope.filters =
      time: 'month'
      initials: ''
      order: 'value'
    $scope.collapse =
      filters: false

    $scope.filter = ->
      $scope.scores = Score.query($scope.filters)

    $scope.on_resize = (window_size) ->
      $scope.collapse.filters = window_size.width < 768

    $scope.filter()
  ]
