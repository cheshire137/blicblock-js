'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.blocks = []
    $scope.upcoming = []
    colors = ['magenta', 'yellow', 'blue', 'green']
    rows = 7
    cols = 5
    for row in [0...rows]
      for col in [0...cols]
        $scope.blocks.push new Block
          color: colors[Math.floor(Math.random() * colors.length)]
          x: row
          y: col
    $scope.upcoming.push new Block
      color: colors[Math.floor(Math.random() * colors.length)]
    $scope.upcoming.push new Block
      color: colors[Math.floor(Math.random() * colors.length)]
