'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:HowToPlayModalCtrl
 # @description
 # # HowToPlayModalCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'HowToPlayModalCtrl', ['$rootScope', '$scope', '$modal', ($rootScope, $scope, $modal) ->
    $scope.open = ->
      $rootScope.$broadcast 'pause'
      modal_instance = $modal.open
        templateUrl: 'how-to-play-modal-content.html'
        controller: 'HowToPlayModalInstanceCtrl'
      on_ok = ->
        $rootScope.$broadcast 'resume'
      on_cancel = on_ok
      modal_instance.result.then on_ok, on_cancel
  ]
