'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:HowToPlayModalInstanceCtrl
 # @description
 # # HowToPlayModalInstanceCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'HowToPlayModalInstanceCtrl', ['$scope', '$modalInstance', ($scope, $modalInstance) ->
    $scope.ok = ->
      $modalInstance.close()
    $scope.cancel = ->
      $modalInstance.dismiss('cancel')
  ]
