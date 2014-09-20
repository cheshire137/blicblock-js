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
    $scope.blocks.push new Block
      color: 'magenta'
      x: 0
      y: 0
    $scope.blocks.push new Block
      color: 'yellow'
      x: 1
      y: 0
    $scope.blocks.push new Block
      color: 'green'
      x: 2
      y: 0
    $scope.blocks.push new Block
      color: 'blue'
      x: 3
      y: 0
    $scope.blocks.push new Block
      color: 'magenta'
      x: 4
      y: 0
