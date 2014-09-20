'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
