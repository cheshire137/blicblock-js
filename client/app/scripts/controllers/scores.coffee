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
      time: 'all'
      initials: ''
      order: 'value'
    $scope.scores = Score.query()

    $scope.filter = ->
      $scope.scores = Score.query($scope.filters)
  ]
