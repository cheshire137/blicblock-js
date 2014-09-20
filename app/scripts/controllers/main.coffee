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

    for row_idx in [0...rows]
      row = new BlockRow()
      for col_idx in [0...cols]
        row.append new Block
          color: colors[Math.floor(Math.random() * colors.length)]
          x: row_idx
          y: col_idx
      $scope.blocks.push row

    $scope.upcoming.push new Block
      color: colors[Math.floor(Math.random() * colors.length)]
    $scope.upcoming.push new Block
      color: colors[Math.floor(Math.random() * colors.length)]
