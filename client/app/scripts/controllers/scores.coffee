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
      time: 'week'
      initials: ''
      order: 'value'

    $scope.filter = ->
      $scope.scores = Score.query($scope.filters)

    $scope.filter()
  ]
