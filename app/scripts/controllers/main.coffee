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
    colors = ['magenta', 'yellow', 'blue', 'green']
    rows = 7
    cols = 5
    for row in [0...rows]
      for col in [0...cols]
        idx = Math.floor(Math.random() * colors.length)
        console.log row, col, colors[idx]
        $scope.blocks.push new Block
          color: colors[idx]
          x: row
          y: col

