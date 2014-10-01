'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:NotificationsCtrl
 # @description
 # # NotificationsCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'NotificationsCtrl', ['$scope', '$cookieStore', 'Notification', ($scope, $cookieStore, Notification) ->
    $scope.notices = Notification.notices
    $scope.errors = Notification.errors

    $scope.remove = (notification_type, notification_id) ->
      Notification.remove notification_type, notification_id

    error = $cookieStore.get('error')
    if error
      Notification.error error
      $cookieStore.remove('error')
  ]
